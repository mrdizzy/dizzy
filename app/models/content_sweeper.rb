class ContentSweeper < ActionController::Caching::Sweeper
	
	# TODO Make sweeper regenerate content pages upon category modification
	# TODO Make sweeper regenerate PDF after new PDF uploaded
	
	observe Content, Section
	
	def after_save(record)
		expire_content_page(record)
		expire_latest_page(record)
		expire_welcome_page(record)
	end
	
	def after_destroy(record)
		expire_content_page(record)
		expire_latest_page(record)
		expire_welcome_page(record)
	end
	
	private
	
	def expire_content_page(record)
		content = record.is_a?(Content) ? record : record.content
		if content.is_a?(Cheatsheet)			
			expire_page hash_for_cheatsheet_path(:id => content.permalink)
			content.sections.each do |section|
				expire_page hash_for_cheatsheet_section_path(:cheatsheet_id => content.permalink, :id => section.permalink)
			end	
		end
		expire_page hash_for_content_path(:id => content.permalink)
		expire_page hash_for_formatted_content_path(:id => content.permalink, :format => :png)
		expire_page hash_for_formatted_content_path(:id => content.permalink, :format => :pdf)	
		
	end
	
	def expire_latest_page(record)
		expire_page hash_for_latest_path
	end
	
	def expire_welcome_page(record)
		expire_page(:controller => :welcome)
	end
end
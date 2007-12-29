# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	# Stylesheets
	
	def core_front_end_stylesheets
		stylesheet_link_tag("main", :media => "all") +
		stylesheet_link_tag("header_footer", :media => "all") +
		stylesheet_link_tag("typography", :media => "all") +
		stylesheet_link_tag("forms", :media => "all") +
		stylesheet_link_tag("lists", :media => "all") +
		stylesheet_link_tag("tables", :media => "all")
	end
	
	# Links
    
    def article_link(object)
    	link_to object.title, { :controller => :content, :action => :show, :permalink => object.permalink }
    end

	def posted_in(categories)
		result = []		
		categories.each do |category|
			result <<
		 (link_to category.name, {:controller => :content, :action => :articles_for_category, :permalink => category.permalink })
		end
		"<span class=\"blue_bold\">Posted in</span> " + diamond + " " + result.to_sentence(:skip_last_comma => true)
	end

	# Graphics
		
	def asterisk
		image_tag("f/bullets/pixels/asterisk.png", :size=> "13x13", :alt => "*")
	end
	
	def bigarrow
		image_tag("f/bullets/pixels/bigarrow.png", :size=> "17x13", :alt => "->")
	end	
	
	def bigleftarrow
		image_tag("f/bullets/arrows/bigleftarrow.png", :size=> "17x13", :alt => "->")
	end		
	
	def diamond
		image_tag("f/bullets/pixels/diamond.png", :size=> "5x5", :alt => "*")
	end
	
	def solid_arrow
		image_tag("f/bullets/arrows/solidarrow.png", :size=> "13x9", :alt => ">")
	end
	
	def spiro
		"<div class=\"spiro\"> &nbsp;</div>"
	end
		
	def submit_button
			submit_tag '', { :class => 'submit' } 
	end
	
	def visible?(input)
		if input 
			diamond
		end
	end 	

	# Footer
	def get_random_companies
		@five_random_companies = Company.find(:all, :order => 'RAND()', :limit => 5)
	end

end

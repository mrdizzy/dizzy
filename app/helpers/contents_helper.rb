module ContentsHelper
		
	def parse_cheatsheet_xml(content)
		content = "Use numbered headers: true
HTML use syntax: true

" + content
		result = Maruku.new(content).to_html
		result
	end

	def pdf_thumbnail(content)
		link_to image_tag(formatted_content_path(:id => content.permalink, :format => "png")), formatted_cheatsheet_path(content.permalink, "pdf")
	end
end

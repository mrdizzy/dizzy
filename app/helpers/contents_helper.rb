module ContentsHelper

	def pdf_thumbnail(content)
		link_to image_tag(formatted_content_path(:id => content.permalink, :format => "png")), formatted_cheatsheet_path(content.permalink, "pdf")
	end
end

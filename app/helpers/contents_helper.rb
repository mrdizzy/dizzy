module ContentsHelper

require 'coderay.rb'
require 'digest/md5'
require 'logger'
require 'strscan'
		
	def parse_cheatsheet_xml(content)
		result = BlueCloth.new(content).to_html
		result
	end

	def pdf_thumbnail(content)
		link_to image_tag(formatted_content_path(:id => content.permalink, :format => "png")), formatted_cheatsheet_path(content.permalink, "pdf")
	end


end

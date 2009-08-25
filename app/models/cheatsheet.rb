class Cheatsheet < Content
	
	has_one :pdf, :dependent => :destroy, :foreign_key => "content_id"
	
	validates_presence_of :pdf
	validates_associated :pdf
	
	def parsed_content
		result = "Use numbered headers: true
HTML use syntax: true

{:rhtml: lang=rhtml html_use_syntax=true}
{:ruby: lang=ruby  html_use_syntax=true}
{:plaintext: lang=plaintext html_use_syntax=true}

# Table of Contents

* Table of Contents
{:toc}

" + self.content
		result = Maruku.new(result).to_html
	end
	
	def binary_attributes=(binaries)
			pdf_data 		= binaries[:pdf][:uploaded_data]
			thumbnail_data 	= binaries[:thumbnail][:uploaded_data]
		
		if self.new_record?		
			unless pdf_data.blank?			
				self.build_pdf(:filename 		=> pdf_data.original_filename,
								:content_type 	=> pdf_data.content_type.chomp,
								:binary_data 	=> pdf_data.read,
								:size			=> pdf_data.size)
			end
		else
			unless pdf_data.blank?					
				self.pdf.update_attributes(:filename 		=> pdf_data.original_filename,
								:content_type 	=> pdf_data.content_type.chomp,
								:binary_data 	=> pdf_data.read,
								:size			=> pdf_data.size)
			end
		end
	end
	
	def title
		result = super 
		result + " Cheatsheet" if result
	end
end


# == Schema Info
# Schema version: 20090603225630
#
# Table name: contents
#
#  id          :integer(4)      not null, primary key
#  version_id  :integer(4)
#  content     :text
#  date        :datetime
#  description :string(255)
#  permalink   :string(255)
#  title       :string(255)
#  type        :string(255)
#  user        :string(255)
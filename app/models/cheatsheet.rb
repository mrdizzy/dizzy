class Cheatsheet < Content

	has_binary :pdf, 
				   :content_type => /(application\/pdf|binary\/octet-stream)/,
				   :size => 1.kilobyte..700.kilobytes
				   	
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
	
	def title
		result = super 
		result + " Cheatsheet" if result
	end
end

# == Schema Info
# Schema version: 20090918003951
#
# Table name: contents
#
#  id               :integer(4)      not null, primary key
#  version_id       :integer(4)
#  content          :text
#  date             :datetime
#  description      :string(255)
#  has_toc          :boolean(1)
#  pdf_binary_data  :binary(16777215
#  pdf_content_type :string(255)
#  pdf_filename     :string(255)
#  permalink        :string(255)
#  title            :string(255)
#  type             :string(255)
#  user             :string(255)
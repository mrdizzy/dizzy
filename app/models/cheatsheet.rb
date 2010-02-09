class Cheatsheet < Content

	has_binary :pdf, 
				   :content_type => /(application\/pdf|binary\/octet-stream)/,
				   :size => 1.kilobyte..700.kilobytes
	def has_toc() true end
	
	def title
		result = super 
		result + " Cheatsheet" if result
	end
end

# == Schema Info
# Schema version: 20090919133116
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
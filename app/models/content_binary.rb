class ContentBinary < ActiveRecord::Base
  belongs_to :content
  
  def uploaded_data=(binary_data)
		unless binary_data.blank?
			#self.filename = binary_data.original_filename			
			self.binary_data = binary_data.read
			#self.size = binary_data.size
		end
	end
end

class TicketCollateral < ActiveRecord::Base
		belongs_to :ticket
	validates_presence_of :name, :body, :content_type
	
	def data_file=(input_data)
		
     self.name = input_data.original_filename
     self.body = input_data.read
     self.content_type = input_data.content_type.chomp

   end
end

# == Schema Information
# Schema version: 6
#
# Table name: ticket_collaterals
#
#  id           :integer(11)   not null, primary key
#  name         :string(255)   
#  body         :binary        
#  ticket_id    :integer(11)   
#  content_type :string(255)   
#

class TicketCollateral < ActiveRecord::Base
		belongs_to :ticket
	validates_presence_of :name, :body, :content_type
	
	def data_file=(input_data)
		
     self.name = input_data.original_filename
     self.body = input_data.read
     self.content_type = input_data.content_type.chomp

   end
end

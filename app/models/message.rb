class Message < ActiveRecord::Base
	
	validates_presence_of :email, :name
	validates_confirmation_of :email
	
	after_save :deliver_message

	acts_as_textcaptcha
	
	def deliver_message
		Mercury.deliver_new_message(self)
	end
  
end

# == Schema Info
# Schema version: 20090827143534
#
# Table name: messages
#
#  id         :integer(4)      not null, primary key
#  email      :string(255)
#  message    :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
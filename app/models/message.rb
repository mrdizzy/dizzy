class Message < ActiveRecord::Base
		validates_presence_of :email, :name, :message
	validates_confirmation_of :email

end

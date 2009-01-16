class Message < ActiveRecord::Base
	validates_confirmation_of :email
end

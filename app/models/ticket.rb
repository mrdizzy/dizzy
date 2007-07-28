class Ticket < ActiveRecord::Base
	has_many :recipients
	has_many :from_recipients
	has_many :cc_recipients
	has_many :to_recipients
	has_many :ticket_collaterals, :dependent => :destroy
	has_many :emails, :through => :recipients
	belongs_to :conversation
 
 	def email_ids=(email_ids)
 		to_recipients.each do |recipient|
      		recipient.destroy unless email_ids.include? recipient.email_id
     	end
     
     email_ids.each do |email_id|
      self.to_recipients.create(:email_id => email_id) unless to_recipients.any? { |c| c.email_id == email_id }
     end
   end
end

class IncomingTicket < Ticket	
end

class OutgoingTicket < Ticket	
end
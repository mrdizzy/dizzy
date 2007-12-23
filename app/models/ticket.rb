# == Schema Information
# Schema version: 6
#
# Table name: tickets
#
#  id              :integer(11)   not null, primary key
#  initial_report  :text          
#  conversation_id :integer(11)   
#  type            :string(255)   
#  date            :datetime      
#

class Ticket < ActiveRecord::Base
	has_many :recipients, :dependent => :destroy
	has_many :from_recipients
	has_many :cc_recipients
	has_many :to_recipients
	has_many :ticket_collaterals, :dependent => :destroy
	has_many :emails, :through => :recipients
	belongs_to :conversation
 
 	def to_recipients=(email_ids)
 		to_recipients.each do |recipient|
      		recipient.destroy unless email_ids.include? recipient.email_id
     	end
     
     email_ids.each do |email_id|
      self.to_recipients.create(:email_id => email_id) unless to_recipients.any? { |c| c.email_id == email_id }
     end
   end
    
 	def cc_recipients=(email_ids)
 		cc_recipients.each do |recipient|
      		recipient.destroy unless email_ids.include? recipient.email_id
     	end
     
     email_ids.each do |email_id|
      self.cc_recipients.create(:email_id => email_id) unless cc_recipients.any? { |c| c.email_id == email_id }
     end
   end
end

class IncomingTicket < Ticket	
end

class OutgoingTicket < Ticket	
end

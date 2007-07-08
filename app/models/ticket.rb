class Ticket < ActiveRecord::Base
	has_many :ticket_collaterals, :dependent => :destroy
	belongs_to :email
	belongs_to :conversation
	
end

class IncomingTicket < Ticket
	
end

class OutgoingTicket < Ticket
	
end
class Conversation < ActiveRecord::Base
		has_many :tickets, :dependent => :destroy, :order => "date DESC" 
	belongs_to :customer
	#has_many :emails, :through => :customer
	
	def parse_code
		"DIZY-#{id}-"
	end
end

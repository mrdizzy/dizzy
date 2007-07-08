class Customer < ActiveRecord::Base
		has_many :conversations, :dependent => :destroy, :order => "id DESC"
	has_many :tickets, :through => :conversations
	has_many :emails, :dependent => :destroy

	
end

class PotentialCustomer < Customer
	
end

class ExistingCustomer < Customer

end
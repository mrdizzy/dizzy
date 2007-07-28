class Person < ActiveRecord::Base

	has_and_belongs_to_many :conversations
	has_many :tickets, :through => :conversations
	has_many :emails, :dependent => :destroy
	belongs_to :person_type

end

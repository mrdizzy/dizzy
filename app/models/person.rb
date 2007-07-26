class Person < ActiveRecord::Base

	has_many :conversations, :dependent => :destroy, :order => "id DESC"
	has_many :tickets, :through => :conversations
	has_many :emails, :dependent => :destroy
	belongs_to :person_type

end

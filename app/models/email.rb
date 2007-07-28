class Email < ActiveRecord::Base
	belongs_to :person
	has_many :recipients
	has_many :tickets, :through => :recipients
	validates_uniqueness_of :email
	validates_presence_of :email
	validates_format_of :email,
		:with => /(\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,6})/,
		:message => "format is invalid"
end

class Email < ActiveRecord::Base
	belongs_to :customer
	has_many :tickets
	validates_uniqueness_of :email
	validates_presence_of :email
	validates_format_of :email,
		:with => /(\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,6})/,
		:message => "format is invalid"
end

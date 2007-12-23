# == Schema Information
# Schema version: 6
#
# Table name: emails
#
#  id        :integer(11)   not null, primary key
#  email     :string(255)   
#  person_id :integer(11)   
#

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

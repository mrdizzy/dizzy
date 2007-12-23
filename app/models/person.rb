# == Schema Information
# Schema version: 6
#
# Table name: people
#
#  id             :integer(11)   not null, primary key
#  firstname      :string(255)   
#  surname        :string(255)   
#  person_type_id :integer(11)   
#

class Person < ActiveRecord::Base

	has_and_belongs_to_many :conversations
	has_many :tickets, :through => :conversations
	has_many :emails, :dependent => :destroy
	belongs_to :person_type

end

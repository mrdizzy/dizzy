# == Schema Information
# Schema version: 6
#
# Table name: person_types
#
#  id          :integer(11)   not null, primary key
#  description :string(255)   
#

class PersonType < ActiveRecord::Base
	has_many :people
end

# == Schema Information
# Schema version: 4
#
# Table name: polls
#
#  id         :integer(11)   not null, primary key
#  name       :string(255)   
#  created_at :datetime      
#

class Poll < ActiveRecord::Base
	has_many :votes
	validates_presence_of :name
	validates_uniqueness_of :name
end

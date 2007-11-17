class Poll < ActiveRecord::Base
	has_many :votes
	validates_presence_of :name
	validates_uniqueness_of :name
end
# == Schema Information
# Schema version: 4
#
# Table name: votes
#
#  id      :integer(11)   not null, primary key
#  poll_id :integer(11)   
#  option  :string(255)   
#  total   :integer(11)   
#

class Vote < ActiveRecord::Base
	belongs_to :poll
	validates_presence_of :option
end

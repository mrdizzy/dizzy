# == Schema Information
# Schema version: 6
#
# Table name: folders
#
#  id        :integer(11)   not null, primary key
#  name      :string(255)   
#  parent_id :integer(11)   
#

class Folder < ActiveRecord::Base
	acts_as_tree :order => :name
end

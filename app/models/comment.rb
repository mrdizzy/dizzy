# == Schema Information
# Schema version: 34
#
# Table name: comments
#
#  id :integer(11)   not null, primary key
#

class Comment < ActiveRecord::Base
	belongs_to :article
	acts_as_tree :order => :subject
end

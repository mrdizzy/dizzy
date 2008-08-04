# == Schema Information
# Schema version: 4
#
# Table name: sections
#
#  id         :integer(11)   not null, primary key
#  body       :text          
#  content_id :integer(11)   
#  title      :string(255)   
#  summary    :string(255)   
#  permalink  :string(255)   
#

class Section < ActiveRecord::Base
	belongs_to :content
	validates_presence_of :title, :summary, :permalink
	validates_existence_of :content
	validates_uniqueness_of :permalink
end

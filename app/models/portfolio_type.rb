class PortfolioType < ActiveRecord::Base
	
	default_scope :order => :description
	
	has_many 					:portfolio_items, :dependent => :destroy
	
	validates_presence_of		:description, :column_space
	validates_presence_of		:position, :unless => Proc.new { |portfolio_type| portfolio_type.visible == false }
	
	validates_uniqueness_of 	:description
	validates_uniqueness_of		:position, :allow_blank => true
	
	validates_inclusion_of		:column_space, :in => 1..3, :message => "should be between 1 and 3"
	validates_numericality_of	:position, :allow_blank => true

end

# == Schema Info
# Schema version: 20090919133116
#
# Table name: portfolio_types
#
#  id           :integer(4)      not null, primary key
#  column_space :integer(4)
#  description  :string(40)
#  position     :integer(4)
#  visible      :boolean(1)      default(TRUE)
# == Schema Information
#
# Table name: portfolio_types
#
#  id           :integer(4)      not null, primary key
#  description  :string(40)
#  column_space :integer(4)
#  position     :integer(4)
#  visible      :boolean(1)      default(TRUE)
#


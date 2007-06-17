# == Schema Information
# Schema version: 34
#
# Table name: companies
#
#  id          :integer(11)   not null, primary key
#  name        :string(40)    
#  description :string(255)   
#

class Company < ActiveRecord::Base
	has_many :portfolio_types
	has_many :portfolio_items, :dependent => :destroy

	validates_presence_of :description, :name
	validates_uniqueness_of :name
	
	def validate
  		if portfolio_items.map(&:portfolio_type_id) != portfolio_items.map(&:portfolio_type_id).uniq
    		errors.add_to_base "Portfolio items must all be of a different type"
  		end
	end 
end

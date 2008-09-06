# == Schema Information
# Schema version: 4
#
# Table name: companies
#
#  id          :integer(11)   not null, primary key
#  name        :string(40)    
#  description :string(255)   
#  visible     :boolean(1)    
#

class Company < ActiveRecord::Base
	
	has_many :portfolio_items, :dependent => :destroy
	has_many :portfolio_types, :through => :portfolio_items
	validates_presence_of :description, :name
	validates_uniqueness_of :name
	
	def validate
  		if portfolio_items.map(&:portfolio_type_id) != portfolio_items.map(&:portfolio_type_id).uniq
    		errors.add_to_base "Portfolio items must all be of a different type"
  		end
  		
  		# Make sure that company has a header graphic
  		header = portfolio_items.collect { |item| item if item.portfolio_type_id == 7}.compact

  		if header.first.nil?
  			errors.add_to_base "Company must have a header graphic"
  		end	
	end 
	
	def portfolio_items_for_display
		self.portfolio_items.visible.find(:all, :order => "portfolio_types.position")
	end

end

class Company < ActiveRecord::Base

	has_many :portfolio_items, :dependent => :destroy
	has_many :portfolio_types, :through => :portfolio_items
	
	default_scope :order => :name
	
	accepts_nested_attributes_for :portfolio_items
	
	validates_presence_of :description, :name
	validates_uniqueness_of :name
	
	def validate
  		if portfolio_items.map(&:portfolio_type_id) != portfolio_items.map(&:portfolio_type_id).uniq
    		errors.add_to_base "Portfolio items must all be of a different type"
  		end
  		
  	   errors.add_to_base "Company must have a header graphic" unless portfolio_items.any? {|item| item.portfolio_type.description == "Header" }
	end 

	def self.pages(page)
		paginate :per_page => 5, :order => :name, :page => page
	end
	
	def portfolio_items_for_display
		self.portfolio_items.visible.all(:order => "portfolio_types.position")
	end
	
end

# == Schema Info
# Schema version: 20090918003951
#
# Table name: companies
#
#  id          :integer(4)      not null, primary key
#  description :string(255)
#  name        :string(40)
#  visible     :boolean(1)
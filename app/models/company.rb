class Company < ActiveRecord::Base

	has_many :portfolio_items, :dependent => :destroy
	has_many :portfolio_types, :through => :portfolio_items
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
		self.portfolio_items.visible.find(:all, :order => "portfolio_types.position")
	end
	
	def new_portfolio_items=(new_portfolio_items)
		new_portfolio_items.each do |item|
			self.portfolio_items.build(item)
		end
	end
   
   def existing_portfolio_items=(existing_portfolio_items)
      self.portfolio_items.each do |item| 
         item.update_attributes(existing_portfolio_items[item.id.to_s]) unless existing_portfolio_items[item.id.to_s].nil?  
      end
   end

end

# == Schema Info
# Schema version: 20090827143534
#
# Table name: companies
#
#  id          :integer(4)      not null, primary key
#  description :string(255)
#  name        :string(40)
#  visible     :boolean(1)
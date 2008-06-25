class AddVisibleToCompanies < ActiveRecord::Migration
  def self.up
  	add_column :companies, :visible, :boolean, :default => false
  	
  	companies = Company.find(14,5,6,10,11)
  	companies.each do |company|
  		company.visible = true
  		company.save!
  	end
  end

  def self.down
  	remove_column :companies, :visible
  end
end

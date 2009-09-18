class PortfolioItem < ActiveRecord::Base
	
	belongs_to 	:portfolio_type
	belongs_to	:company	
	
	validates_uniqueness_of :portfolio_type_id, :scope => 'company_id', :message => "must be unique"
	
	validates_binary :image, :content_type => /png$/i, :size => 1.byte..100.kilobytes
					 
	validates_existence_of :portfolio_type
	
	named_scope :visible, { :conditions => ("portfolio_types.visible = '1'"), :include => "portfolio_type"}
	named_scope :header, { :conditions => "portfolio_type_id = '7'" }
	
end

# == Schema Info
# Schema version: 20090918003951
#
# Table name: portfolio_items
#
#  id                 :integer(4)      not null, primary key
#  company_id         :integer(4)      not null, default(0)
#  portfolio_type_id  :integer(4)      not null, default(0)
#  image_binary_data  :binary
#  image_content_type :string(255)
#  image_filename     :string(255)
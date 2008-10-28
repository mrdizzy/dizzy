# == Schema Information
# Schema version: 13
#
# Table name: portfolio_items
#
#  id                :integer(4)    not null, primary key
#  portfolio_type_id :integer(4)    default(0), not null
#  company_id        :integer(4)    default(0), not null
#  content_type      :string(255)   
#  filename          :string(255)   
#  size              :integer(4)    
#  data              :binary        
#

class PortfolioItem < ActiveRecord::Base
	validates_uniqueness_of :portfolio_type_id, :scope => 'company_id', :message => "must not be a duplicate"
	validates_format_of :content_type,
						:with => /(gif|png)$/i,
						:message => "must be a PNG or GIF file"
	validates_inclusion_of		:size, :in => 1.kilobyte..100.kilobytes,:message => "must be between 1kb and 100kb"
	validates_presence_of :filename
	validates_presence_of :content_type
	validates_presence_of :data
	belongs_to 	:portfolio_type
	belongs_to	:company
	validates_existence_of :portfolio_type
	
	named_scope :visible, { :conditions => ("portfolio_types.visible = '1'"), :include => "portfolio_type"}
	named_scope :header, { :conditions => "portfolio_type_id = '7'" }
	
	def uploaded_data=(binary_data)
		self.filename = binary_data.original_filename
		self.content_type = binary_data.content_type.chomp
		self.data = binary_data.read
		self.size = binary_data.size
	end
	
end

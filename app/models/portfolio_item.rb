class PortfolioItem < ActiveRecord::Base
	
	attr_writer :content_type
	
	belongs_to 	:portfolio_type
	belongs_to	:company
	
	validates_uniqueness_of :portfolio_type_id, :scope => 'company_id', :message => "must be unique"
	validates_format_of :content_type,
						:with => /png$/i,
						:message => "must be a PNG file"
	validates_inclusion_of		:size, :in => 1.byte..100.kilobytes, :message => "must be between 1kb and 100kb"
	validates_presence_of :data
	validates_existence_of :portfolio_type
	
	named_scope :visible, { :conditions => ("portfolio_types.visible = '1'"), :include => "portfolio_type"}
	named_scope :header, { :conditions => "portfolio_type_id = '7'" }
	
	def content_type
		@content_type ? @content_type : "image/png" 
	end
	
	def uploaded_data=(binary_data)   
		self.data = binary_data.read
		self.size = binary_data.size
	end
	
end

# == Schema Info
# Schema version: 20090827143534
#
# Table name: portfolio_items
#
#  id                :integer(4)      not null, primary key
#  company_id        :integer(4)      not null, default(0)
#  portfolio_type_id :integer(4)      not null, default(0)
#  data              :binary
#  size              :integer(4)
# == Schema Information
# Schema version: 4
#
# Table name: portfolio_items
#
#  id                :integer(11)   not null, primary key
#  portfolio_type_id :integer(11)   
#  company_id        :integer(11)   
#  content_type      :string(255)   
#  filename          :string(255)   
#  size              :integer(11)   
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
	belongs_to	:company, :order => "portfolio_types.position"
	
	def uploaded_data=(binary_data)
		self.filename = binary_data.original_filename
		self.content_type = binary_data.content_type.chomp
		self.data = binary_data.read
		self.size = binary_data.size
	end
	
	def validate
		#if company.nil?
		#	errors.add(:company_id, "must exist in the database")
		#end
		if portfolio_type.nil?
			errors.add(:portfolio_type_id, "must exist in the database")
		end
	end
end

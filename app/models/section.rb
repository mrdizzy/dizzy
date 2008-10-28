# == Schema Information
# Schema version: 13
#
# Table name: sections
#
#  id         :integer(4)    not null, primary key
#  body       :text          
#  content_id :integer(4)    default(0), not null
#  title      :string(255)   
#  summary    :string(255)   
#  permalink  :string(255)   
#

class Section < ActiveRecord::Base
	belongs_to :content
	validates_presence_of :title, :summary, :permalink
	validates_existence_of :content
	validates_uniqueness_of :permalink
	validates_format_of		:permalink, :with => /^[a-z0-9-]+$/, :allow_blank => true
	
	def self.find_by_content_id_and_permalink(content_id,permalink)
		result = find(:first, :conditions => ["permalink = ? AND content_id = ?", permalink, content_id])
		unless result 
			raise ActiveRecord::RecordNotFound 
		else
			result
		end	
	end
end

class Section < ActiveRecord::Base
	belongs_to :content
	validates_uniqueness_of :permalink
end

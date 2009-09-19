class Version < ActiveRecord::Base
	
	has_many :contents
	
	validates_presence_of :version_number
	validates_format_of :version_number, :with => /^(\d|\.)+$/, :allow_blank => true
	validates_uniqueness_of :version_number
end

# == Schema Info
# Schema version: 20090918003951
#
# Table name: versions
#
#  id             :integer(4)      not null, primary key
#  version_number :string(255)
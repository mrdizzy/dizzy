class Version < ActiveRecord::Base
	
	# TODO Create foreign keys in database
	has_many :contents
	validates_presence_of :version_number
	
	# TODO: Create regex for validation version numbers
	validates_numericality_of :version_number
	validates_uniqueness_of :version_number
end


# == Schema Info
# Schema version: 20090603225630
#
# Table name: versions
#
#  id             :integer(4)      not null, primary key
#  version_number :string(255)
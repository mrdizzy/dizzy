# == Schema Information
# Schema version: 4
#
# Table name: versions
#
#  id             :integer(11)   not null, primary key
#  version_number :string(255)   
#


class Version < ActiveRecord::Base
	has_many :contents
end

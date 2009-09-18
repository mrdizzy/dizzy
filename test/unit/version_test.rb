require File.dirname(__FILE__) + '/../test_helper'

class VersionTest < ActiveSupport::TestCase

  def test_truth
    assert true
  end
  
  def test_1_should_fail_when_not_unique
  	version = Factory(:version)
	version_duplicate = Factory.build(:version)
	version_duplicate.version_number = version.version_number
  	version_duplicate.valid?
  	assert_equal "has already been taken", version_duplicate.errors.on(:version_number)
  end
  
  def test_2_should_fail_when_not_valid_version_number
	invalid_version_numbers = ["two", "2_1", "2,1", "j.2", "2'1", "2@1", "2 1", "52<"]
	invalid_version_numbers.each do |n|
		version = Factory.build(:version, :version_number => n)
		version.valid?
		assert_equal "is invalid", version.errors.on(:version_number), n
	end
  end

  def test_3_should_succeed_when_valid_version_number		
	valid_version_numbers = ["1", "2", "3.2.1", "4.0", "3.2"]
	valid_version_numbers.each do |n|
		version = Factory.build(:version, :version_number => n)
		assert version.valid?, "#{version.errors.full_messages}" + n
	end
  end
  
  def test_4_should_fail_with_empty_version_number
	version = Factory.build(:version, :version_number => "")
	assert !version.valid?
	assert_equal "can't be blank", version.errors[:version_number]
	
	version.version_number = nil
	assert !version.valid?
	assert_equal "can't be blank", version.errors[:version_number]
  end
  
end

# == Schema Info
# Schema version: 20090918003951
#
# Table name: versions
#
#  id             :integer(4)      not null, primary key
#  version_number :string(255)
require File.dirname(__FILE__) + '/../test_helper'

class VersionTest < Test::Unit::TestCase

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
	flunk
  end
  
	def test_3_should_succeed_when_valid_version_number		
	  flunk
  end
    
  
end

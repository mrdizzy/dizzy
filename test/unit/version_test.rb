require File.dirname(__FILE__) + '/../test_helper'

class VersionTest < Test::Unit::TestCase
	
	fixtures :versions

  def test_truth
    assert true
  end
  
  def test_should_fail_when_not_unique
  	version = Version.new(:version_number => "2.0")
  	version.valid?
  	assert_equal "has already been taken", version.errors.on(:version_number)
  end
  
  def test_should_fail_when_not_valid_version_number

  end
  
	def test_should_succeed_when_valid_version_number		
	  
  end
    
  
end

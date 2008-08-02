require File.dirname(__FILE__) + '/../test_helper'

class VersionTest < Test::Unit::TestCase
	
	fixtures :versions

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_should_fail_when_not_unique
  	version = Version.new(:version_number => "2.0")
  	version.valid?
  	assert_equal "has already been taken", version.errors.on(:version_number)
  end
  
  def test_should_fail_when_not_valid_version_number
  	invalids = [ "one", "2_0", "2.A", "2 0" ]
  	invalids.each do |invalid|
  		version = Version.new(:version_number => invalid)
  		version.valid?
  		assert_equal "is not a number", version.errors.on(:version_number)
  	end
  end
  
	def test_should_succeed_when_valid_version_number		
	  	valid_versions = [ "1.3", "1", "2.3", "2.4.2", "2.0.2" ]
	  	valid_versions.each do |valid_version|
	  		version = Version.new(:version_number => valid_version)
	  		assert version.valid?, version.errors.full_messages
	  	end 
  end
    
  
end

require File.dirname(__FILE__) + '/../test_helper'

class BinaryTest < Test::Unit::TestCase
	fixtures :contents, :categories, :categories_contents, :binaries

  def test_binaries_should_be_destroyed_when_content_deleted
  	binary = binaries(:rails_migrations_pdf)
  	content = Content.find(binary.content_id)
  	content.destroy
 	binaries = Binary.find_all_by_content_id(binary.content_id)
 	assert_equal 0, binaries.size, "Binaries should have been destroyed"
  end
  
  def test_binary_should_fail_on_invalid_content_id
  	binary = binaries(:rails_migrations_pdf)
  	binary.content_id = 342
  	assert !binary.valid?, "Binary should be invalid"
  	assert_equal "does not exist", binary.errors.on(:content)
  end

  def test_binary_should_fail_on_null_content_id
  	binary = binaries(:rails_migrations_pdf)
  	binary.content_id = nil
  	assert !binary.valid?, "Binary should be invalid"
  	assert_equal "does not exist", binary.errors.on(:content)
  end
  
end
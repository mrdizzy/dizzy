require File.dirname(__FILE__) + '/../test_helper'

class CategoryTest < Test::Unit::TestCase
  fixtures :categories, :contents, :binaries, :categories_contents

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_should_fail_with_empty_attributes
	category = Category.new
	assert !category.valid?
	assert_equal category.errors[:name], "can't be blank"
	assert_equal category.errors[:permalink], "can't be blank"
	assert_equal category.errors.full_messages, ["Name can't be blank", "Permalink can't be blank"]
	assert category.errors.invalid?(:name)
	assert category.errors.invalid?(:permalink)
	assert_equal category.errors.count, 2
  end

  def test_should_fail_on_create_with_invalid_permalink
  	bad_permalinks = ["underscore_not_valid", "&no-!weird-%#\"/'characters)$", "no spaces", "NO-CAPITALS"]
  	bad_permalinks.each do |permalink|
  		category = Category.new(:name => "New Category", :permalink => permalink)
  		assert !category.valid?, "Permalink #{permalink} should be invalid"
  		assert_equal category.errors[:permalink], "is invalid"
  	 	assert_nil category.errors[:name] 	 	 
	end
  end 
  
  def test_should_succeed_on_create_with_valid_permalink
  	good_permalinks = ["valid-category-name", "rails-2-and-jeffrey", "wembley"]
  	good_permalinks.each do |permalink|
  		category = Category.new(:name => "New Category", :permalink => permalink)
  	 	assert category.valid?  	 
	end
  end

  def test_should_fail_on_create_with_duplicate_name
  	duplicate = Category.new(:name => "Plugins", :permalink => "abc-def-ghi")
  	assert !duplicate.valid?, "Category name should be invalid"
  	assert_equal duplicate.errors[:name], "has already been taken"
  	assert_nil duplicate.errors[:category]
  	end

  def test_should_fail_on_create_with_duplicate_permalink
  	duplicate = Category.new(:name => "Melanie", :permalink => "plugins")
  	assert !duplicate.valid?, "Category permalink should be invalid"
  	assert_equal duplicate.errors[:permalink], "has already been taken"
  	assert_nil duplicate.errors[:name]
  end 	  
  
end

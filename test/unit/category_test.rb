require File.dirname(__FILE__) + '/../test_helper'

class CategoryTest < Test::Unit::TestCase
  fixtures :categories

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_should_fail_invalid_with_empty_attributes
	category = Category.new
	assert !category.valid?
	assert category.errors.invalid?(:name)
	assert category.errors.invalid?(:permalink)
  end

  def test_should_fail_duplicate_permalinks
  	duplicate = Category.new(:name => "Melanie", :permalink => "plugins")
  	assert !duplicate.valid?, "Category permalink should be invalid"
  end
  
  def test_should_fail_duplicate_category_names
  	duplicate = Category.new(:name => "Plugins", :permalink => "abc-def-ghi")
  	assert !duplicate.valid?, "Category name should be invalid"
  	end
  	
  def test_should_fail_permalink_with_bad_characters
  	bad_permalinks = ["underscore_not_valid", "&no-!weird-%characters)$", "no spaces", "NO-CAPITALS"]
  	bad_permalinks.each do |permalink|
  		category = Category.new(:name => "New Category", :permalink => permalink)
  		assert !category.valid?, "Permalink #{permalink} should be invalid"
  	 end
  end 
  
  def test_should_succeed_with_valid_permalinks
  	good_permalinks = ["valid-category-name", "rails-2-and-jeffrey", "wembley"]
  	good_permalinks.each do |permalink|
  		category = Category.new(:name => "New Category", :permalink => permalink)
  		assert category.valid?, "Permalink #{permalink} should be valid"
  	 end
  end
  
end

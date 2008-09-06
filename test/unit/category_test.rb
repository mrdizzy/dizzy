require File.dirname(__FILE__) + '/../test_helper'

class CategoryTest < Test::Unit::TestCase
  fixtures :categories, :contents, :binaries

  def test_truth
    assert true
    assert categories(:beginners).valid?, categories(:beginners).errors.full_messages 
    assert categories(:file_handling).valid?, categories(:file_handling).errors.full_messages
    assert categories(:cheatsheets).valid?, categories(:cheatsheets).errors.full_messages
    assert categories(:action_mailer).valid?, categories(:action_mailer).errors.full_messages
    assert categories(:helpers).valid?, categories(:helpers).errors.full_messages
  end
  
  def test_should_fail_with_empty_attributes
	category = Category.new
	assert !category.valid?
	assert_equal category.errors.full_messages, ["Name can't be blank", "Permalink can't be blank"]
	assert_equal category.errors.count, 2
  end

  def test_should_fail_on_create_with_invalid_permalink
  	bad_permalinks = ["underscore_not_valid", "&no-!weird-%#\"/'characters)$", "no spaces", "NO-CAPITALS"]
  	bad_permalinks.each do |permalink|
  		category = Category.new(:name => "New Category", :permalink => permalink)
  		assert !category.valid?, "Permalink #{permalink} should be invalid"
  		assert_equal category.errors[:permalink], "is invalid"
  	 	assert_equal 1, category.errors.size 	 
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
  	duplicate = Category.new(:name => "Action Mailer", :permalink => "abc-def-ghi")
  	assert !duplicate.valid?, "Category name should be invalid"
  	assert_equal duplicate.errors[:name], "has already been taken"
  	assert_equal 1, duplicate.errors.size
  	end

  def test_should_fail_on_create_with_duplicate_permalink
  	duplicate = Category.new(:name => "Melanie", :permalink => "file-handling")
  	assert !duplicate.valid?, "Category permalink should be invalid"
  	assert_equal duplicate.errors[:permalink], "has already been taken"
  	assert_equal 1, duplicate.errors.size
  end 	  
  
  def test_should_remove_category_and_association_when_destroyed
  	category = categories(:beginners)
  	assert_difference('Category.count', -1) do
    	category.destroy
	end
	category = categories(:cheatsheets)
	assert_difference('category.contents.size', -2) do 
		category.destroy
	end
  end
  
end
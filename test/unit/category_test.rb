require File.dirname(__FILE__) + '/../test_helper'

class CategoryTest < Test::Unit::TestCase
  
  def test_truth
    assert true
  end
  
  def test_1_should_fail_with_empty_attributes
	category = Category.new
	assert !category.valid?
	assert_equal category.errors.full_messages, ["Name can't be blank", "Permalink can't be blank"]
	assert_equal category.errors.count, 2
  end

  def test_2_should_fail_on_create_with_invalid_permalink
  	bad_permalinks = ["underscore_not_valid", "&no-!weird-%#\"/'characters)$", "no spaces", "NO-CAPITALS"]
	category = Factory.build(:category)
  	bad_permalinks.each do |permalink|
  		category.permalink = permalink
  		assert !category.valid?, "Permalink #{permalink} should be invalid"
  		assert_equal category.errors[:permalink], "is invalid"
  	 	assert_equal 1, category.errors.size 	 
	end
  end 
  
  def test_3_should_succeed_on_create_with_valid_permalink
  	good_permalinks = ["valid-category-name", "rails-2-and-jeffrey", "wembley"]
  	good_permalinks.each do |permalink|
  		category = Category.new(:name => "New Category", :permalink => permalink)
  	 	assert category.valid?  	 
	end
  end

  def test_4_should_fail_on_create_with_duplicate_name
  	duplicate = Category.new(:name => "Action Mailer", :permalink => "abc-def-ghi")
	duplicate.save!
	duplicate2 = Category.new(:name => "Action Mailer", :permalink => "boo-dee-goo")
  	assert !duplicate2.valid?, "Category name should be invalid"
  	assert_equal "has already been taken", duplicate2.errors[:name]
  	assert_equal 1, duplicate2.errors.size
  	end

  def test_5_should_fail_on_create_with_duplicate_permalink
  	duplicate = Category.new(:name => "Melanie", :permalink => "file-handling")
	duplicate.save!
	duplicate2 = Category.new(:name => "Hermintrude", :permalink => "file-handling")
	
  	assert !duplicate2.valid?, "Category permalink should be invalid"
  	assert_equal "has already been taken", duplicate2.errors[:permalink]
  	assert_equal 1, duplicate2.errors.size
  end 	  
  
  def test_6_should_remove_category
	categories = []
    10.times do |n|
		categories << Factory(:category)
	end
  	assert_difference('Category.count', -2) do
  		2.times { |n| categories.shift.destroy }
  	end
  end
  
end

# == Schema Info
# Schema version: 20090603225630
#
# Table name: categories
#
#  id        :integer(4)      not null, primary key
#  name      :string(255)
#  permalink :string(255)
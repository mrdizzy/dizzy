require File.dirname(__FILE__) + '/../test_helper'

class CategoryTest < ActiveSupport::TestCase
  
  def test_truth
    assert true
  end
  
  def test_1_should_fail_with_empty_name
	category = Factory.build(:category, :name => "")
	assert !category.valid?
	assert_equal "can't be blank", category.errors[:name]
	assert_equal 1, category.errors.size
  end
  
  def test_2_should_fail_with_empty_permalink
 category = Factory.build(:category, :permalink => "")
	assert !category.valid?
	assert_equal "can't be blank", category.errors[:permalink]
	assert_equal 1, category.errors.size
  end

  def test_3_should_fail_on_create_with_invalid_permalink
  	bad_permalinks = ["underscore_not_valid", "&no-!weird-%#\"/'characters)$", "no spaces", "NO-CAPITALS"]
	category = Factory.build(:category)
  	bad_permalinks.each do |permalink|
  		category.permalink = permalink
  		assert !category.valid?, "Permalink #{permalink} should be invalid"
  		assert_equal category.errors[:permalink], "is invalid"
  	 	assert_equal 1, category.errors.size 	 
	end
  end 
  
  def test_4_should_succeed_on_create_with_valid_permalink
  	good_permalinks = ["valid-category-name", "rails-2-and-jeffrey", "wembley"]
  	good_permalinks.each do |permalink|
  		category = Category.new(:name => "New Category", :permalink => permalink)
  	 	assert category.valid?  	 
	end
  end

  def test_5_should_fail_on_create_with_duplicate_name
   category = Factory(:category)
  	duplicate = Factory.build(:category, :name => category.name)
   assert !duplicate.valid?, "Category name should be invalid"
  	assert_equal "has already been taken", duplicate.errors[:name]
  	assert_equal 1, duplicate.errors.size
  	end

  def test_6_should_fail_on_create_with_duplicate_permalink
   category = Factory(:category)
  	duplicate = Factory.build(:category, :permalink => category.permalink)
   assert !duplicate.valid?, "{Permalink should be invalid"
  	assert_equal "has already been taken", duplicate.errors[:permalink]
  	assert_equal 1, duplicate.errors.size  
  end 	  
  
  def test_7_should_remove_category
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
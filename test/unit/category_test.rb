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
  
  def test_8_should_find_by_permalink
    category = Factory(:category)
    result = Category.find_by_permalink(category.permalink)
    assert_equal category, result, "Two categories should be identical"
  end
  
  def test_9_should_raise_error_if_permalink_not_found
    assert_raise(ActiveRecord::RecordNotFound) { Category.find_by_permalink("no-such-permalink") }
  end
  
  def test_a_should_display_articles_in_order_of_time
  
   cheatsheet_oldest = Factory(:cheatsheet, :date => 10.days.ago, :pdf => ActionController::TestUploadedFile.new("../fixtures/rails-migrations.pdf", "application/pdf", :binary))
   
   cheatsheet_latest = Factory(:cheatsheet, :date => Time.now, :pdf => ActionController::TestUploadedFile.new("../fixtures/rails-migrations.pdf", "application/pdf", :binary))
   cheatsheet_middle = Factory(:article, :date => 5.days.ago)
   
   assert [cheatsheet_latest, cheatsheet_middle, cheatsheet_oldest].all? { |c| c.valid? }, "Cheatsheets are invalid"
   
   category = Factory(:category, :contents => [ cheatsheet_middle, cheatsheet_oldest, cheatsheet_latest ])
   
   assert category.save
   category = Category.find(category.id)
   assert_equal [ cheatsheet_latest, cheatsheet_middle, cheatsheet_oldest ], category.contents, "Should be contents in order"
  end
  
  def test_b_should_raise_error_when_category_not_found
    assert_raise(ActiveRecord::RecordNotFound) { Category.find_by_permalink("hello-david") }
  end
  
  def test_c_categories_should_be_ordered_alphabetically_by_name
    category_1, category_2, category_3, category_4, category_5 = Factory(:category), Factory(:category), Factory(:category), Factory(:category, :name => "B Category"), Factory(:category, :name => "A Category")
    categories = Category.all
    assert_equal [ category_5, category_4, category_1, category_2, category_3 ], categories
  end
  
end

# == Schema Info
# Schema version: 20090919133116
#
# Table name: categories
#
#  id        :integer(4)      not null, primary key
#  name      :string(255)
#  permalink :string(255)
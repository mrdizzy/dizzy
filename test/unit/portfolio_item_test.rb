require File.dirname(__FILE__) + '/../test_helper'
require 'pp'

class PortfolioItemTest < ActiveSupport::TestCase

  def test_truth; assert true; end
        
  def test_1_portfolio_item_must_be_between_1k_and_100k
    flunk
  end
  
  def test_2_bad_content_type_must_be_invalid 
  	bad 	= %w(image/jpg image/jpeg audio/wav image/tiff image/pngg image/giff image/png/audio)
  	factory = Factory.build(:portfolio_item)

  	bad.each do |content_type|   		
      factory.image_content_type = content_type
                          
      assert !factory.valid?, factory.errors.full_messages
      assert_equal 1, factory.errors.size, "Should only be 1 error but #{factory.errors.size} errors: #{factory.errors.full_messages}"
      assert_equal "is invalid", factory.errors.on(:image_content_type), "Content type should have error"
    end
  end  
  
  def test_3_good_content_type_must_be_valid
    factory = Factory.build(:portfolio_item)

    %w(image/png image/x-png).each do |content_type|
      factory.image_content_type = content_type	
  		assert factory.valid?, factory.errors.full_messages
  	end
  end  
  
  def test_4_portfolio_item_must_be_destroyed_upon_company_deletion
    company = Factory(:company)
    
    assert_difference('PortfolioItem.count', (0 - company.portfolio_items.size)) do
      company.destroy
    end
  end
  
  def test_5_portfolio_type_id_must_be_unique_to_company
  	company = Factory(:company)
    portfolio_item = company.portfolio_items.first 
    portfolio_item_dup = Factory.build(:portfolio_item, :company => company, 
                                                        :portfolio_type => portfolio_item.portfolio_type)
    assert !portfolio_item_dup.valid?,  portfolio_item_dup.errors.full_messages
    assert_equal "must be unique", portfolio_item_dup.errors.on(:portfolio_type_id)
  end    

  def test_6_portfolio_type_id_must_exist
  	portfolio_item = Factory.build(:portfolio_item, :portfolio_type_id => 423232)
  	assert !portfolio_item.valid?, "Portfolio item should be invalid"
  	assert_equal "does not exist", portfolio_item.errors.on(:portfolio_type)
  end
  
end

# == Schema Info
# Schema version: 20090919133116
#
# Table name: portfolio_items
#
#  id                 :integer(4)      not null, primary key
#  company_id         :integer(4)      not null, default(0)
#  portfolio_type_id  :integer(4)      not null, default(0)
#  image_binary_data  :binary
#  image_content_type :string(255)
#  image_filename     :string(255)
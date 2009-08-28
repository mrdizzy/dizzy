require File.dirname(__FILE__) + '/../test_helper'

class PortfolioItemTest < ActiveSupport::TestCase

  def test_truth
    assert true
  end
    
  def test_1_portfolio_item_must_be_between_1k_and_100k
  	portfolio_item = Factory.build(:portfolio_item)
  	
    portfolio_item.size = 150.kilobytes
    assert !portfolio_item.valid?, portfolio_item.errors.full_messages
    assert_equal "must be between 1kb and 100kb", portfolio_item.errors.on(:size)
    
    portfolio_item.size = 800.bytes
    assert !portfolio_item.valid?, portfolio_item.errors.full_messages
    assert_equal "must be between 1kb and 100kb", portfolio_item.errors.on(:size)
    
    portfolio_item.size = 100.kilobytes
    assert portfolio_item.valid?, portfolio_item.errors.full_messages
  end
  
  def test_2_bad_content_type_must_be_invalid
 
  	bad 	= %w(image/jpg image/jpeg audio/wav image/tiff image/pngg image/giff image/png/audio)
  	factory = Factory.build(:portfolio_item)
  	bad.each do |content_type|   		
      factory.content_type = content_type
                          
      assert !factory.valid?,  factory.errors.full_messages
      assert_equal "must be a PNG file", factory.errors.on(:content_type), "Content type should have error"
    end
  end  
  
  def test_3_good_content_type_must_be_valid
  	good	= %w(image/png image/x-png)
    factory = Factory.build(:portfolio_item)
    
    good.each do |content_type|
      factory.content_type = content_type
											
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
    assert_equal "must not be a duplicate", portfolio_item_dup.errors.on(:portfolio_type_id)
  end    

  def test_6_portfolio_type_id_must_exist
  	portfolio_item = Factory.build(:portfolio_item, :portfolio_type_id => 423232)
  	assert !portfolio_item.valid?, "Portfolio item should be invalid"
  	assert_equal "does not exist", portfolio_item.errors.on(:portfolio_type)
  end
  
end

# == Schema Info
# Schema version: 20090827143534
#
# Table name: portfolio_items
#
#  id                :integer(4)      not null, primary key
#  company_id        :integer(4)      not null, default(0)
#  portfolio_type_id :integer(4)      not null, default(0)
#  data              :binary
#  size              :integer(4)
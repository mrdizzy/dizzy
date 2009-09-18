require File.dirname(__FILE__) + '/../test_helper'
require 'pp'
class PortfolioItemTest < ActiveSupport::TestCase

  def test_truth
    assert true
  end
    
  def test_1_portfolio_item_must_be_between_1k_and_100k
  	portfolio_item = Factory.build(:portfolio_item, :image => ActionController::TestUploadedFile.new("../fixtures/letterhead.png", "image/png"))
    portfolio_item.image_size = 150.kilobytes
    assert !portfolio_item.valid?, portfolio_item.errors.full_messages
    assert_equal "must be between 1kb and 100kb", portfolio_item.errors.on(:image_size), portfolio_item.errors.full_messages
    
    portfolio_item.image_size = 800.bytes
    assert !portfolio_item.valid?, portfolio_item.errors.full_messages
    assert_equal "must be between 1kb and 100kb", portfolio_item.errors.on(:image_size), portfolio_item.errors.full_messages
    
    portfolio_item.image_size = 100.kilobytes
    assert portfolio_item.valid?, portfolio_item.errors.full_messages
  end
  
  def test_2_bad_content_type_must_be_invalid
 
  	bad 	= %w(image/jpg image/jpeg audio/wav image/tiff image/pngg image/giff image/png/audio)
  	factory = Factory.build(:portfolio_item, :image => ActionController::TestUploadedFile.new("../fixtures/letterhead.png", "image/png"))
  	bad.each do |content_type|   		
      factory.image_content_type = content_type
                          
      assert !factory.valid?,  factory.errors.full_messages
      assert_equal "must be a PNG file", factory.errors.on(:image_content_type), "Content type should have error"
    end
  end  
  
  def test_3_good_content_type_must_be_valid
  	good	= %w(image/png image/x-png)
    factory = Factory.build(:portfolio_item, :image => ActionController::TestUploadedFile.new("../fixtures/letterhead.png", "image/png"))
    
    good.each do |content_type|
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
    portfolio_item_dup = Factory.build(:portfolio_item, :image => ActionController::TestUploadedFile.new("../fixtures/letterhead.png", "image/png"), :company => company, 
                                                        :portfolio_type => portfolio_item.portfolio_type)
							
    assert !portfolio_item_dup.valid?,  portfolio_item_dup.errors.full_messages
    assert_equal "must be unique", portfolio_item_dup.errors.on(:portfolio_type_id)
  end    

  def test_6_portfolio_type_id_must_exist
  	portfolio_item = Factory.build(:portfolio_item, :image => ActionController::TestUploadedFile.new("../fixtures/letterhead.png", "image/png"), :portfolio_type_id => 423232)
  	assert !portfolio_item.valid?, "Portfolio item should be invalid"
  	assert_equal "does not exist", portfolio_item.errors.on(:portfolio_type)
  end
  
end

# == Schema Info
# Schema version: 20090918003951
#
# Table name: portfolio_items
#
#  id                 :integer(4)      not null, primary key
#  company_id         :integer(4)      not null, default(0)
#  portfolio_type_id  :integer(4)      not null, default(0)
#  image_binary_data  :binary
#  image_content_type :string(255)
#  image_filename     :string(255)
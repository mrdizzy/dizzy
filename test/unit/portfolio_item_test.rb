require File.dirname(__FILE__) + '/../test_helper'

class PortfolioItemTest < Test::Unit::TestCase
  fixtures :portfolio_items
  fixtures :companies

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_portfolio_item_must_be_between_1k_and_100k
  	portfolio_item = portfolio_items(:heavenly_logo)
  	portfolio_item.size = 150.kilobytes
  	assert !portfolio_item.valid?, portfolio_item.errors.full_messages
  	portfolio_item.size = 800.bytes
  	assert !portfolio_item.valid?, portfolio_item.errors.full_messages
  	portfolio_item.size = 100.kilobytes
  	assert portfolio_item.valid?, portfolio_item.errors.full_messages
  end
  
  def test_portfolio_item_must_belong_to_valid_company
  	portfolio_item = portfolio_items(:heavenly_logo)
  	portfolio_item.portfolio_type_id = 2
  	portfolio_item.company_id = 88232
  	assert !portfolio_item.valid?, portfolio_item.errors.full_messages
  end
  
  def test_portfolio_item_must_be_destroyed_upon_company_deletion
  	portfolio_items = PortfolioItem.find_all_by_company_id(1)  
  	assert_equal 7, portfolio_items.size
  	company = Company.find(1)
  	company.destroy
	portfolio_items = PortfolioItem.find_all_by_company_id(1)  	
	assert_equal 0, portfolio_items.size
  end
  
  def test_portfolio_type_id_must_be_unique_to_company
  	existing_portfolio_type = PortfolioItem.new( 	:portfolio_type_id 	=> "3",
													:company_id 		=> "1",
													:content_type 		=> "image/png",
													:filename 			=> "colourlogo.png",
													:data				=> portfolio_items(:heavenly_logo).data)
													
	assert !existing_portfolio_type.save,  existing_portfolio_type.errors.full_messages
  end    
  
  def test_portfolio_type_id_parent_must_exist
  	flunk
  end
  
  def test_content_type_must_be_valid
  	bad 	= %w(image/jpg image/jpeg audio/wav image/tiff image/pngg image/giff image/png/audio)
  	good	= %w(image/png image/x-png image/gif)
  	
  	bad.each do |content_type| 
		valid_content_type = PortfolioItem.new(	:portfolio_type_id	=> "2",
												:company_id 		=> "1",
												:content_type 		=> content_type,
												:filename 			=> "letterhead.png",
												:size 				=> "3644",
												:data				=> portfolio_items(:heavenly_logo).data)
														
		assert !valid_content_type.valid?,  valid_content_type.errors.full_messages
	end
	
	good.each do |content_type|
		valid_content_type = PortfolioItem.new( :portfolio_type_id	=> "2",
												:company_id 		=> "1",
												:content_type 		=> content_type,
												:filename 			=> "letterhead.png",
												:size 				=> "3644",
												:data				=> portfolio_items(:heavenly_logo).data)
  		assert valid_content_type.valid?, valid_content_type.errors.full_messages
  	end
  end    
end
require File.dirname(__FILE__) + '/../test_helper'

class PortfolioItemTest < Test::Unit::TestCase
	  fixtures :portfolio_items, :portfolio_types, :companies

  def test_truth
    assert true
  end
  
    def test_portfolio_item_must_be_between_1k_and_100k
  	portfolio_item = portfolio_items(:heavenly_logo)
  	
  	portfolio_item.size = 150.kilobytes
  	assert !portfolio_item.valid?, portfolio_item.errors.full_messages
  	assert_equal "must be between 1kb and 100kb", portfolio_item.errors.on(:size)
  	
  	portfolio_item.size = 800.bytes
  	assert !portfolio_item.valid?, portfolio_item.errors.full_messages
  	assert_equal "must be between 1kb and 100kb", portfolio_item.errors.on(:size)
  	
  	portfolio_item.size = 100.kilobytes
  	assert portfolio_item.valid?, portfolio_item.errors.full_messages
  end
  
  def test_content_type_must_be_valid
  	bad 	= %w(image/jpg image/jpeg audio/wav image/tiff image/pngg image/giff image/png/audio)
  	
  	bad.each do |content_type| 
  		
		valid_content_type = PortfolioItem.new(	:portfolio_type	=> portfolio_types(:letterhead),
												:company_id		=> companies(:silver).id,
												:content_type 		=> content_type,
												:filename 			=> "letterhead.png",
												:size 				=> "3644",
												:data				=> portfolio_items(:heavenly_logo).data)
												
		assert !valid_content_type.valid?,  valid_content_type.errors.full_messages
		assert_equal "must be a PNG or GIF file", valid_content_type.errors.on(:content_type)
	end
	
	good	= %w(image/png image/x-png image/gif)
	
	good.each do |content_type|
		valid_content_type = PortfolioItem.new( :portfolio_type	=> portfolio_types(:letterhead),
												:company 		=> companies(:silver),
												:content_type 		=> content_type,
												:filename 			=> "letterhead.png",
												:size 				=> "3644",
												:data				=> portfolio_items(:heavenly_logo).data)
  		assert valid_content_type.valid?, valid_content_type.errors.full_messages
  	end
  end    
  
  def test_portfolio_item_must_be_destroyed_upon_company_deletion
		flunk
  end
  
  def test_portfolio_type_id_must_be_unique_to_company
  	existing_portfolio_type = PortfolioItem.new( 	:portfolio_type_id		=> portfolio_types(:letterhead).id,
													:company 			=> companies(:heavenly),
													:content_type 		=> "image/png",
													:filename 			=> "colourlogo.png",
													:data				=> portfolio_items(:heavenly_logo).data)
													
	assert !existing_portfolio_type.valid?,  existing_portfolio_type.errors.full_messages
	assert_equal "must not be a duplicate", existing_portfolio_type.errors.on(:portfolio_type_id)
  end    

  def test_portfolio_type_id_must_exist
  	portfolio_item = portfolio_items(:heavenly_logo)
  	portfolio_item.portfolio_type_id = 323
  	assert !portfolio_item.valid?
  	assert_equal "does not exist", portfolio_item.errors.on(:portfolio_type)
  end
  
end
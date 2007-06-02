require File.dirname(__FILE__) + '/../test_helper'

class PortfolioItemTest < Test::Unit::TestCase
  fixtures :portfolio_items

  # Replace this with your real tests.
  def test_truth
    assert true
  end

  def test_valid_portfolio_item 
  	valid_logo = PortfolioItem.new(	:portfolio_type_id 	=> "2",
									:company_id 		=> "1",
									:content_type 		=> "image/png",
									:filename 			=> "letterhead.png",
									:size 				=> "3644",
									:data				=> portfolio_items(:dizzy_logo).data)
													
	assert valid_logo.save,  valid_logo.errors.full_messages
  end
  
  def test_unique_portfolio_type 
  	invalid_logo = PortfolioItem.new( 	:portfolio_type_id 	=> "1",
										:company_id 		=> "1",
										:content_type 		=> "image/png",
										:filename 			=> "colourlogo.png",
										:data				=> portfolio_items(:dizzy_logo).data)
													
	assert !invalid_logo.save,  invalid_logo.errors.full_messages
  end    
  
  def test_content_type 
  	bad 	= %w(image/jpg image/jpeg audio/wav image/tiff image/pngg image/giff image/png/audio)
  	good	= %w(image/png image/x-png image/gif)
  	
  	bad.each do |content_type| 
		valid_content_type = PortfolioItem.new(	:portfolio_type_id	=> "3",
												:company_id 		=> "1",
												:content_type 		=> content_type,
												:filename 			=> "letterhead.png",
												:size 				=> "3644",
												:data				=> portfolio_items(:dizzy_logo).data)
														
		assert !valid_content_type.valid?,  valid_content_type.errors.full_messages
	end
	
	good.each do |content_type|
		valid_content_type = PortfolioItem.new( :portfolio_type_id	=> "3",
												:company_id 		=> "1",
												:content_type 		=> content_type,
												:filename 			=> "letterhead.png",
												:size 				=> "3644",
												:data				=> portfolio_items(:dizzy_logo).data)
  		assert valid_content_type.valid?, valid_content_type.errors.full_messages
  	end
  end    
end
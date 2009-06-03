require File.dirname(__FILE__) + '/../test_helper'

class PortfolioItemTest < Test::Unit::TestCase
	  fixtures :portfolio_items, :portfolio_types, :companies

  def test_truth
    assert true
  end
  
  def test_fixtures_valid
  	 PortfolioItem.all.each do |item|
  	 	assert item.valid?, item.errors.full_messages
  	 end
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
  
  def test_bad_content_type_must_be_invalid
  	bad 	= %w(image/jpg image/jpeg audio/wav image/tiff image/pngg image/giff image/png/audio)
  	
  	bad.each do |content_type| 
  		
		valid_content_type = PortfolioItem.new(	:portfolio_type	=> portfolio_types(:letterhead),
												:company_id		=> companies(:silver).id,
												:content_type 	=> content_type,
												:size			=> 56.kilobytes,
												:data			=> portfolio_items(:heavenly_letterhead).data )
												
		assert !valid_content_type.valid?,  valid_content_type.errors.full_messages
		assert_equal "must be a PNG file", valid_content_type.errors.on(:content_type), "Content type should have error"
	end
  end  
  
  def test_good_content_type_must_be_valid
  	good	= %w(image/png image/x-png)
	
	good.each do |content_type|
		valid_content_type = PortfolioItem.new( :portfolio_type	=> portfolio_types(:letterhead),
												:company_id 		=> companies(:silver).id,												
												:size			=> 56.kilobytes,
												:data	=> portfolio_items(:heavenly_letterhead).data ,
												:content_type => content_type)
											
  		assert valid_content_type.valid?, valid_content_type.errors.full_messages
  	end
  end  
  
  def test_portfolio_item_must_be_destroyed_upon_company_deletion
	company = companies(:heavenly)
	portfolio_items = companies(:heavenly).portfolio_items
	
	assert_difference('PortfolioItem.count', (0 - portfolio_items.size)) do
		company.destroy
	end
  end
  
  def test_portfolio_type_id_must_be_unique_to_company
  	existing_portfolio_type = PortfolioItem.new( 	:portfolio_type_id		=> portfolio_types(:letterhead).id,
													:company 			=> companies(:heavenly),
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

# == Schema Info
# Schema version: 20090603225630
#
# Table name: portfolio_items
#
#  id                :integer(4)      not null, primary key
#  company_id        :integer(4)      not null, default(0)
#  portfolio_type_id :integer(4)      not null, default(0)
#  data              :binary
#  size              :integer(4)
require File.dirname(__FILE__) + '/../test_helper'

class PortfolioTypeTest < Test::Unit::TestCase
  fixtures :portfolio_types

  def test_truth
    assert true
  end
  
  def test_fixtures_valid
  	PortfolioType.all.each do |type|
  		assert type.valid?, type.errors.full_messages
  	end
  end

	def test_position_must_be_unique
		product = PortfolioType.new(:description =>		"Huge Billboard Advert",
										:column_space => "3",
										:position => "1")
		assert !product.valid?
		assert_equal "has already been taken", product.errors.on(:position)
		assert_equal 1, product.errors.size
	end    	
		
	def test_description_must_be_unique
		product = PortfolioType.new(:description =>		"Letterhead",
										:column_space => "2",
										:position => "72")
		assert !product.valid?
		assert_equal "has already been taken", product.errors.on(:description)
		assert_equal 1, product.errors.size
	end    		
	
	def test_column_space_must_be_3_or_less
		product = PortfolioType.new(:description =>		"Business card",
										:column_space => "5",
										:position => "82")
		assert !product.valid?
		assert_equal "should be between 0 and 3", product.errors.on(:column_space)
		assert_equal 1, product.errors.size
	end    
end
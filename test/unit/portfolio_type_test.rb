require File.dirname(__FILE__) + '/../test_helper'

class PortfolioTypeTest < Test::Unit::TestCase
  fixtures :portfolio_types

  # Replace this with your real tests.
  def test_truth
    assert true
  end

	def test_unique_position
		product = PortfolioType.new(:description =>		"Business card",
																:column_space => "3",
																	:position => "1")
		assert !product.save
	end    	
		
		def test_unique_description
		product = PortfolioType.new(:description =>		"Letterhead",
																:column_space => "2",
																	:position => "2")
		assert !product.save
	end    		
	
		def test_column_space
		product = PortfolioType.new(:description =>		"Business card",
																:column_space => "5",
																:position => "2")
		assert !product.save
	end    
end
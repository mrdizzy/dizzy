require File.dirname(__FILE__) + '/../test_helper'

class CompanyTest < Test::Unit::TestCase
  fixtures :companies
  fixtures :portfolio_items
  fixtures :portfolio_types

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
	def test_invalid_with_empty_attributes
		company = Company.new
		assert !company.valid?
		assert company.errors.invalid?(:name)
		assert company.errors.invalid?(:description)
	end     
	
	def test_should_fail_if_no_header
		company = companies(:heavenly)
		company.portfolio_items.destroy_all
		assert !company.valid?, "Company should not be valid as no header graphic"
		assert_equal "Company must have a header graphic", company.errors.on_base
	end
end

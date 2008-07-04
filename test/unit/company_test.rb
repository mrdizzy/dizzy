require File.dirname(__FILE__) + '/../test_helper'

class CompanyTest < Test::Unit::TestCase
  fixtures :companies
  fixtures :portfolio_items
  fixtures :portfolio_types

  # Replace this with your real tests.
  def test_truth
    assert true
  end

	
	def test_should_succeed_if_valid_header
		company = companies(:heavenly)
		company.name = "Benefits Agency PLC"
		assert company.valid?, company.errors.full_messages
	end	
end

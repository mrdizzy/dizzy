require File.dirname(__FILE__) + '/../test_helper'

class CompanyTest < Test::Unit::TestCase
  fixtures :companies

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
end

require File.dirname(__FILE__) + '/../test_helper'

class CompanyTest < Test::Unit::TestCase
  fixtures :companies, :portfolio_items, :portfolio_types

  def test_truth
    assert true
  end
  
  def test_fixtures_valid
  	assert_valid companies(:heavenly)
    companies(:heavenly).portfolio_items.all?{|portfolio_item| assert_valid portfolio_item}
  end
  
  def setup
  	@heavenly = companies(:heavenly)
  end
  
	def test_invalid_with_empty_attributes
		company = Company.new
		assert !company.valid?
		assert_equal company.errors.size, 3
	end     
	
	def test_should_fail_if_no_header
		company = companies(:heavenly)
		company.portfolio_items.destroy_all
		assert !company.valid?, "Company should not be valid as no header graphic"
		assert_equal "Company must have a header graphic", company.errors.on_base
	end
	
	def test_should_succeed_if_valid_header
		company = companies(:heavenly)
		company.name = "Benefits Agency PLC"
		assert company.valid?, company.errors.full_messages
	end	
	
	def test_should_destroy_dependencies
		count = @heavenly.portfolio_items.count
		count = 0 - count
		assert_difference('PortfolioItem.count',count) do 
			@heavenly.destroy
		end
	end
	
end


# == Schema Info
# Schema version: 20090603225630
#
# Table name: companies
#
#  id          :integer(4)      not null, primary key
#  description :string(255)
#  name        :string(40)
#  visible     :boolean(1)
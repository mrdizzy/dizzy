require File.dirname(__FILE__) + '/../test_helper'

class CompanyTest < ActiveSupport::TestCase

  def test_truth
    assert true
  end
  
	def test_1_invalid_with_empty_attributes
		company = Factory(:company)
		assert !company.valid?
		assert_equal company.errors.size, 3
	end     

	def test_2_should_fail_if_no_header
		company = Factory.build(:company, :portfolio_items => [])
		assert !company.valid?, "Company should not be valid as no header graphic"
		assert_equal "Company must have a header graphic", company.errors.on_base
	end

	def test_3_should_succeed_if_valid_header
		company = companies(:heavenly)
		company.name = "Benefits Agency PLC"
		assert company.valid?, company.errors.full_messages
	end	

	def test_4_should_destroy_dependencies
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
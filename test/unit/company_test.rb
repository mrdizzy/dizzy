require File.dirname(__FILE__) + '/../test_helper'

class CompanyTest < ActiveSupport::TestCase

  def test_truth
    assert true
  end
  
	def test_1_invalid_with_empty_name
		company = Factory.build(:company, :name => "")
		assert !company.valid?
		assert_equal company.errors.size, 1
		assert_equal "can't be blank", company.errors[:name]
	end     

	def test_1_invalid_with_empty_description
		company = Factory.build(:company, :description => "")
		assert !company.valid?
		assert_equal company.errors.size, 1
		assert_equal "can't be blank", company.errors[:description]
	end     
	
	def test_2_should_fail_if_no_header
		company = Factory.build(:company, :portfolio_items => [])
		assert !company.valid?, "Company should not be valid as no header graphic"
		assert_equal "Company must have a header graphic", company.errors.on_base
	end

	def test_3_should_succeed_if_valid_header
	flunk
	end	

	def test_4_should_destroy_dependencies
		company = Factory(:company)
		company.portfolio_items << [Factory(:portfolio_item), Factory(:portfolio_item), Factory(:portfolio_item)] 
		portfolio_items = company.portfolio_items.size

		assert_difference('PortfolioItem.count', 0 - portfolio_items ) do 
			company.destroy
		end
	end

end

# == Schema Info
# Schema version: 20090918003951
#
# Table name: companies
#
#  id          :integer(4)      not null, primary key
#  description :string(255)
#  name        :string(40)
#  visible     :boolean(1)
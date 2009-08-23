require File.dirname(__FILE__) + '/../test_helper'

class PortfolioTypeTest < ActiveSupport::TestCase

  def test_truth
    assert true
  end
  
	def test_1_position_must_be_unique
    portfolio_type = Factory(:portfolio_type)
		portfolio_type_dup = Factory.build(:portfolio_type, :description => "Letterheads", :position => 2)
		assert !portfolio_type_dup.valid?, portfolio_type_dup.errors.full_messages
		assert_equal "has already been taken", portfolio_type_dup.errors.on(:position), portfolio_type_dup.errors.full_messages
		assert_equal 1, portfolio_type_dup.errors.size, portfolio_type_dup.errors.full_messages
	end    	
		
	def test_2_description_must_be_unique
		portfolio_type = Factory(:portfolio_type)
    portfolio_type_dup = Factory.build(:portfolio_type, :description => "Business cards", :position => 3)
		assert !portfolio_type_dup.valid?, portfolio_type_dup.errors.full_messages
		assert_equal "has already been taken", portfolio_type_dup.errors.on(:description), portfolio_type_dup.errors.full_messages
		assert_equal 1, portfolio_type_dup.errors.size, portfolio_type_dup.errors.full_messages
	end    		
	
	def test_3_column_space_must_be_3_or_less
		portfolio_type = Factory.build(:portfolio_type, :column_space => 4)
		assert !portfolio_type.valid?
		assert_equal "should be between 0 and 3", portfolio_type.errors.on(:column_space), portfolio_type.errors.full_messages
		assert_equal 1, portfolio_type.errors.size,  portfolio_type.errors.full_messages
	end    
  
  def test_4_fails_on_invalid_column_space
    flunk
  end
  
  def test_5_succeeds_on_valid_column_space
    flunk
  end
  
end

# == Schema Info
# Schema version: 20090603225630
#
# Table name: portfolio_types
#
#  id            :integer(4)      not null, primary key
#  column_space  :integer(4)
#  description   :string(40)
#  header_binary :binary
#  position      :integer(4)
#  visible       :boolean(1)      default(TRUE)
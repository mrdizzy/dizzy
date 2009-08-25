require File.dirname(__FILE__) + '/../test_helper'

class PortfolioTypeTest < ActiveSupport::TestCase

  def test_truth
    assert true
  end
  
  def test_1_position_must_be_unique
    portfolio_type = Factory(:portfolio_type)
		portfolio_type_dup = Factory.build(:portfolio_type, :position => portfolio_type.position)
    
		assert !portfolio_type_dup.valid?, portfolio_type_dup.errors.full_messages
		assert_equal "has already been taken", portfolio_type_dup.errors.on(:position), portfolio_type_dup.errors.full_messages
		assert_equal 1, portfolio_type_dup.errors.size, portfolio_type_dup.errors.full_messages
	end    	
		
	def test_2_description_must_be_unique
		portfolio_type = Factory(:portfolio_type)
    portfolio_type_dup = Factory.build(:portfolio_type, :description => portfolio_type.description)
    
		assert !portfolio_type_dup.valid?, portfolio_type_dup.errors.full_messages
		assert_equal "has already been taken", portfolio_type_dup.errors.on(:description), portfolio_type_dup.errors.full_messages
		assert_equal 1, portfolio_type_dup.errors.size, portfolio_type_dup.errors.full_messages
	end    		
	
	def test_3_column_space_must_be_3_or_less
		portfolio_type = Factory.build(:portfolio_type)
    
    [4, 0, 7, 100, 1000].each do |column_space|
      portfolio_type.column_space = column_space
      assert !portfolio_type.valid?, "Should be invalid: #{column_space}" 
      assert_equal "should be between 1 and 3", portfolio_type.errors[:column_space], portfolio_type.errors.full_messages
      assert_equal 1, portfolio_type.errors.size,  portfolio_type.errors.full_messages
    end
	end    
  
  def test_4_fails_with_empty_description
    portfolio_type = Factory.build(:portfolio_type, :description => "")
    assert !portfolio_type.valid?
    assert_equal 1, portfolio_type.errors.size
    assert_equal "can't be blank", portfolio_type.errors[:description]
  end
  
  def test_5_fails_with_empty_position_when_visible_is_true
    portfolio_type = Factory.build(:portfolio_type, :position => "", :visible => true)
    assert !portfolio_type.valid?
    assert_equal 1, portfolio_type.errors.size
    assert_equal "can't be blank", portfolio_type.errors[:position]
  end
  
  def test_6_is_valid_when_empty_position_when_visible_is_false
    portfolio_type = Factory.build(:portfolio_type, :position => "", :visible => false)
    assert portfolio_type.valid?
  end
  
  def test_7_allow_more_than_one_blank_position
    5.times do |n|
     assert Factory(:portfolio_type, :position => "", :visible => false).valid?
    end
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
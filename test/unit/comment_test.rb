require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < ActiveSupport::TestCase

  def test_truth
    assert true
  end
  
  def test_1_should_fail_blank_comment
  	comment = Comment.new
  	assert !comment.valid?, comment.errors.full_messages
  	assert comment.errors.count, 5
  end
  
  def test_2_should_fail_invalid_email
  	comment = Factory.build(:comment)
  	
  	bad_addresses = ["melinda@@dizzy.co.uk", "jamie@192.34.32.43", "louise@louise", "mr_habadashery@*bloo.com"]
  	bad_addresses.each do |address|
  		comment.email = address
  		assert !comment.valid?, comment.errors.full_messages
  		assert_equal "must contain a valid address", comment.errors.on(:email)
  	end
  end

  def test_3_should_pass_valid_email
  	comment = Factory.build(:comment)
  	
  	good_addresses = %w{ melinda@dizzy.co.uk jamie@dizzy.com louise.smith@germany.de mr_lewis@lewis.co.uk david.pettifer@dizzy.co.uk jamie.han@motif-switcher.com }
  	good_addresses.each do |address|
  		comment.email = address
  		assert comment.valid?, comment.errors.full_messages
  	end
  end
  
  def test_4_should_fail_with_invalid_parent
  	comment = Factory(:comment)
  	comment.parent_id = 13434
  	assert !comment.valid?, comment.errors.full_messages
  	assert_equal "does not exist", comment.errors.on(:parent)
  end
  
  def test_5_should_pass_with_valid_parent
  	parent = Factory(:comment)
	child = Factory(:comment)
	child.parent_id = parent.id
  	assert child.valid?, child.errors.full_messages
  end
  
  def test_6_should_fail_without_linked_article
  	comment = Factory.build(:comment)
  	comment.content_id = 23232
  	assert !comment.valid?, comment.errors.full_messages
  	assert_equal "does not exist", comment.errors.on(:content)
  end
  
  def test_8_should_have_children
  	grandmother = Factory(:comment)
	mother 		= Factory(:comment)
	sibling1	= Factory(:comment)
	sibling2	= Factory(:comment)
	
	mother.parent_id = grandmother.id
	mother.save
	
	assert_equal 1, grandmother.children.count
	assert_equal mother, grandmother.children.first
	
	sibling1.parent_id = mother.id
	sibling2.parent_id = mother.id
	sibling1.save
	sibling2.save
	
  	assert_equal 2, mother.children.count
	assert_equal [sibling1,sibling2], mother.children
  	
  	#assert_equal mother.children, [sibling1,sibling2]
  end
end


# == Schema Info
# Schema version: 20090603225630
#
# Table name: comments
#
#  id         :integer(4)      not null, primary key
#  content_id :integer(4)      not null, default(0)
#  parent_id  :integer(4)
#  body       :text
#  email      :string(255)
#  name       :string(255)
#  new        :boolean(1)      default(TRUE)
#  subject    :string(255)
#  created_at :datetime
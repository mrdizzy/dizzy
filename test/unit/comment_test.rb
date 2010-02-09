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
  		assert_equal "must contain a valid address", comment.errors[:email]
      assert_equal 1, comment.errors.size
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
    assert_equal "does not exist", comment.errors[:parent]
    assert_equal 1, comment.errors.size
  end
  
  def test_5_should_pass_with_valid_parent
    parent = Factory(:comment)
    child = Factory(:comment)
    child.parent_id = parent.id
    child.content_id = child.parent.content_id
    assert child.valid?, child.errors.full_messages
  end
  
  def test_6_should_fail_without_linked_article
  	comment = Factory.build(:comment)
  	comment.content_id = 23232
  	assert !comment.valid?, comment.errors.full_messages
  	assert_equal "does not exist", comment.errors.on(:content)
  end

   def test_8_child_should_have_same_content_id_as_parent
      parent = Factory(:comment)
      child = Factory.build(:comment)
      parent.children << child

     assert_equal "must be tied to the same content as parent comment", child.errors[:content_id]
     assert 1, child.errors.count
   end
   
   def test_9_should_fail_with_invalid_content_id
      parent = Factory.build(:comment, :content_id => 1111222342)
      assert !parent.valid?, parent.errors.full_messages
      assert_equal "does not exist", parent.errors[:content]
      assert_equal 1, parent.errors.count
   end
   
   
  def test_a_should_fail_with_empty_content
    parent = Factory.build(:comment, :content => nil)
    assert !parent.valid?, parent.errors.full_messages
    assert_equal "can't be blank", parent.errors[:content_id]
    assert_equal 1, parent.errors.count
  end   
   
  def test_a1_should_display_new_comments_order_newest_first
    comment1 = Factory(:comment, :created_at => Time.now)
    comment2 = Factory(:comment, :created_at => 5.hours.ago)
    comment3 = Factory(:comment, :new => false)
    assert_equal [comment1, comment2], Comment.new_comments, "New comments should be displayed in ascending order"
  end
  
end

# == Schema Info
# Schema version: 20090919133116
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
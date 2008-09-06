require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < Test::Unit::TestCase
 fixtures :comments, :contents

  def test_truth
    assert true
  end
  
  def test_should_fail_blank_comment
  	comment = Comment.new
  	assert !comment.valid?, comment.errors.full_messages
  	assert comment.errors.count, 5
  end
  
  def test_should_fail_invalid_email
  	comment = comments(:grandmother)
  	
  	bad_addresses = ["melinda@@dizzy.co.uk", "jamie@192.34.32.43", "louise@louise", "mr_habadashery@*bloo.com"]
  	bad_addresses.each do |address|
  		comment.email = address
  		assert !comment.valid?, comment.errors.full_messages
  		assert_equal "must contain a valid address", comment.errors.on(:email)
  	end
  end

  def test_should_pass_valid_email
  	comment = comments(:grandmother)
  	
  	good_addresses = %w{ melinda@dizzy.co.uk jamie@dizzy.com louise.smith@germany.de mr_lewis@lewis.co.uk david.pettifer@dizzy.co.uk jamie.han@motif-switcher.com }
  	good_addresses.each do |address|
  		comment.email = address
  		assert comment.valid?, comment.errors.full_messages
  	end
  end
  
  def test_should_fail_with_invalid_parent
  	comment = comments(:mother)
  	comment.parent_id = 13434
  	assert !comment.valid?, comment.errors.full_messages
  	assert_equal "must exist in the database", comment.errors.on(:parent_id)
  end
  
  def test_should_pass_with_valid_parent
  	comment = comments(:daughter)
  	assert comment.valid?, comment.errors.full_messages
  end
  
  def test_should_fail_without_linked_article
  	comment = comments(:mother)
  	comment.content_id = 23232
  	assert !comment.valid?, comment.errors.full_messages
  	assert_equal "must exist in the database", comment.errors.on(:content_id)
  end
  
  def test_should_pass_with_linked_article
  	comment = comments(:mother)
  	assert comment.valid?, comment.errors.full_messages
  end  
  
  def test_should_have_children
  	comments = comments(:great_grandmother)
  	assert_equal comments.children.first, comments(:grandmother)
  	
  	comments = comments(:mother)
  	assert_equal comments.children, [comments(:son),comments(:daughter)]
  end
end

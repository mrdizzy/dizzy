require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < Test::Unit::TestCase
  fixtures :comments

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_should_fail_blank_comment
  	comment = Comment.new
  	assert !comment.valid?, comment.errors.full_messages
  end
  
  def test_should_fail_invalid_email
  	comment = comments(:parent_comment)
  	
  	bad_addresses = ["melinda@@dizzy.co.uk", "jamie@192.34.32.43", "louise@louise", "mr_habadashery@*bloo.com"]
  	bad_addresses.each do |address|
  		comment.email = address
  		assert !comment.valid?, comment.errors.full_messages
  		assert_equal "must contain a valid address", comment.errors.on(:email)
  	end
  end

  def test_should_pass_valid_email
  	comment = comments(:parent_comment)
  	
  	good_addresses = %w{ melinda@dizzy.co.uk jamie@dizzy.com louise.smith@germany.de mr_lewis@lewis.co.uk  david.pettifer@dizzy.co.uk jamie.han@motif-switcher.com }
  	good_addresses.each do |address|
  		comment.email = address
  		assert comment.valid?, comment.errors.full_messages

  	end
  end
  
end

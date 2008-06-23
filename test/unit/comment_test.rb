require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < Test::Unit::TestCase
  fixtures :comments

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_comment
  	comment = comments(:bad_comment)
  end
  
  def test_blank_comment
  	comment = Comment.new
  	assert !comment.valid?
  end
  
end

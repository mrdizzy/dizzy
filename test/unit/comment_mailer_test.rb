require File.dirname(__FILE__) + '/../test_helper'

class CommentMailerTest < ActionMailer::TestCase
  
  def test_1_response_to_parent  	
    mother.children << [ Factory.build(:comment, :content_id => mother.content_id ), Factory.build(:comment, :content_id => mother.content_id) ]
    assert mother.valid?
   
	  response = CommentMailer.create_reply_notification(mother)
   
	  assert_equal "#{mother.name}: a reply to your comment at dizzy.co.uk...", response.subject
	  assert_match /Dear #{mother.name},/, response.body
	  assert_match /Subject: #{mother.subject}/, response.body
	  assert_match /Email: #{mother.children.last.email}/, response.body
	  assert_match /Comment: #{mother.children.last.body}/, response.body
	  assert_equal "#{mother.email}", response.to[0]
	  assert_equal FROM_EMAIL, response.from[0]
  end

	def test_2_notification
		comment = Factory(:comment)
		response = CommentMailer.create_notification(comment)
		assert_equal comment.subject, response.subject
		assert_equal FROM_EMAIL, response.from[0]
	end

end

require File.dirname(__FILE__) + '/../test_helper'

class CommentMailerTest < Test::Unit::TestCase
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"

  fixtures :comments

  include ActionMailer::Quoting

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = false
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
    @expected.mime_version = '1.0'
  end

  def test_response_to_parent
  	comment = comments(:parent_comment)
  	
	response = CommentMailer.create_response(comment)
	assert_equal "#{comment.name}: a reply to your comment at dizzy.co.uk...", response.subject
	assert_match /Dear #{comment.name},/, response.body
	assert_match /Subject: #{comment.subject}/, response.body
	assert_match /Email: #{comment.children.last.email}/, response.body
	assert_match /Comment: #{comment.children.last.body}/, response.body
	assert_equal "#{comment.email}", response.to[0]
	assert_equal FROM_EMAIL, response.from[0]
  end

	def test_notification
		comment = comments(:parent_comment)
		response = CommentMailer.create_notification(comment)
		assert_equal comment.subject, response.subject
		assert_equal FROM_EMAIL, response.from[0]
	end

  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/comment_mailer/#{action}")
    end

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end

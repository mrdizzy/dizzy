require File.dirname(__FILE__) + '/../test_helper'

class BinaryTest < Test::Unit::TestCase
	fixtures :binaries, :contents
	
  def test_truth
  	assert true
  	assert_valid binaries(:action_mailer_pdf)
  	assert_valid binaries(:action_mailer_png)
  end
  
  def setup
  	@action_mailer_pdf = binaries(:action_mailer_pdf)
  	@action_mailer_cheatsheet = contents(:action_mailer_cheatsheet)
  end

  def test_should_destroy_when_content_is_deleted
  	assert_difference("Binary.count",-2) do
  		@action_mailer_pdf.content.destroy
 	end
  end
  
  def test_should_fail_on_invalid_content_id
  	@action_mailer_pdf.content_id = 342
  	assert !@action_mailer_pdf.valid?, "Binary should be invalid"
  	assert_equal "does not exist", @action_mailer_pdf.errors.on(:content)
  end

  def test_should_fail_on_null_content_id
  	@action_mailer_pdf.content_id = nil
  	assert !@action_mailer_pdf.valid?, "Binary should be invalid"
  	assert_equal "does not exist", @action_mailer_pdf.errors.on(:content)
  end
  
end
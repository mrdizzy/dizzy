require File.dirname(__FILE__) + '/../test_helper'

class CheatsheetTest < ActiveSupport::TestCase

  def test_truth
    assert true
  end
  
  #TODO: Rewrite tests
  
  def test_1_should_fail_without_pdf_and_thumbnail

  	#assert !@action_mailer_cheatsheet.valid?
  	#assert_equal ["Thumbnail can't be blank","Pdf can't be blank"], @action_mailer_cheatsheet.errors.full_messages
  end
  
    def test_2_should_destroy_dependencies
  	#assert_difference(['Cheatsheet.count', 'Pdf.count', 'Thumbnail.count'], -1) do
  	#	@action_mailer_cheatsheet.destroy
  	#end
  end
  
end

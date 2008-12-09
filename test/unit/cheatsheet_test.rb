require File.dirname(__FILE__) + '/../test_helper'

class CheatsheetTest < Test::Unit::TestCase
  fixtures :contents, :binaries, :categories, :versions

  def test_truth
    assert true
    assert_valid contents(:action_mailer_cheatsheet)
  end
  
  def setup
  	@action_mailer_cheatsheet	= contents(:action_mailer_cheatsheet)
  	@cheatsheet_without_binaries = contents(:cheatsheet_without_binaries)
  end
  
  def test_should_fail_without_pdf_and_thumbnail
  	assert !@cheatsheet_without_binaries.valid?
  	assert_equal ["Thumbnail can't be blank","Pdf can't be blank"], @cheatsheet_without_binaries.errors.full_messages
  end
  
    def test_should_destroy_dependencies
  	assert_difference(['Cheatsheet.count', 'Pdf.count', 'Thumbnail.count'], -1) do
  		@action_mailer_cheatsheet.destroy
  	end
  end
  
end

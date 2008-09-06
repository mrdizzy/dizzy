require File.dirname(__FILE__) + '/../test_helper'

class ContentTest < Test::Unit::TestCase
  fixtures :contents, :categories, :comments, :users, :versions, :binaries
  
  def test_truth
    assert true
    assert contents(:form_helpers_snippet).valid?, contents(:form_helpers_snippet).errors.full_messages
    assert contents(:action_mailer_cheatsheet).valid?, contents(:action_mailer_cheatsheet).errors.full_messages
    assert contents(:file_uploads_tutorial).valid?, contents(:file_uploads_tutorial).errors.full_messages
    assert !contents(:cheatsheet_without_binaries).valid?
    assert_equal 2,	contents(:cheatsheet_without_binaries).errors.size
  end
   
  def setup
  	@form_helpers = contents(:form_helpers_snippet)
  end
  
  def test_should_fail_without_category
  	@form_helpers.categories.destroy_all
  	assert !@form_helpers.valid?, "Should be invalid without associated categories"
  	assert "must exist", @form_helpers.errors.invalid?(:categories)
  end
  
    def test_invalid_with_empty_attributes
  	cheatsheet = Cheatsheet.new
  	fields = %w{ title description user_id date permalink version_id }  	
  	assert !cheatsheet.valid?
  	fields.each do |field|  		
  		assert cheatsheet.errors.invalid?(field.to_sym), "error on #{field}"
  	end
  end
  
 def test_should_fail_permalink_with_bad_characters
  	bad_permalinks = ["underscore_not_valid", "&no-!weird-%#\"/'characters)$", "no spaces", "NO-CAPITALS"]
  	bad_permalinks.each do |permalink|
  		@form_helpers.permalink = permalink
  		assert "is invalid", @form_helpers.errors.invalid?(:permalink)
  	 end
  end 
  
  def test_should_succeed_with_valid_permalinks
  	good_permalinks = ["valid-category-name", "rails-2-and-jeffrey", "wembley"]
  	good_permalinks.each do |permalink|
  		@form_helpers.permalink = permalink
  		assert @form_helpers.valid?, @form_helpers.errors.full_messages
  	 end
  end
  
    def test_should_fail_duplicate_permalinks
  	duplicate 			= contents(:file_uploads_tutorial)
  	duplicate.permalink = "debugging-form-helpers-with-the-console"
	duplicate.valid?
  	assert duplicate.errors.invalid?(:permalink), "Article should not be valid"
  end
  
    def test_fail_when_empty_body
  	@form_helpers.content = ""
  	assert "can't be empty", @form_helpers.errors.invalid?(:content)
  end
  
  def test_fail_when_empty_title
 	@form_helpers.title = ""
 	assert "can't be empty", @form_helpers.errors.invalid?(:title)
  end
  
end
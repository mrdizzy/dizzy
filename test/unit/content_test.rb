require File.dirname(__FILE__) + '/../test_helper'

class ContentTest < Test::Unit::TestCase
  fixtures :contents, :versions, :categories, :binaries
  
  def test_truth
    assert true
    assert contents(:form_helpers_snippet).valid?, contents(:form_helpers_snippet).errors.full_messages
    assert contents(:action_mailer_cheatsheet).valid?, contents(:action_mailer_cheatsheet).errors.full_messages
    assert contents(:file_uploads_tutorial).valid?, contents(:file_uploads_tutorial).errors.full_messages
  end
   
  def setup
  	@form_helpers_article		= contents(:form_helpers_snippet)
  	@action_mailer_cheatsheet 	= contents(:action_mailer_cheatsheet)
  end
  
  def test_should_fail_with_invalid_version
  	@form_helpers_article.version_id = 231
  	assert !@form_helpers_article.valid?
  	assert_equal 1, @form_helpers_article.errors.size, "Should have at least 1 error"
  	assert_equal "does not exist", @form_helpers_article.errors.on(:version)
  end
  
  def test_should_fail_with_empty_category
  	@form_helpers_article.categories.destroy_all
  	assert !@form_helpers_article.valid?
  	assert_equal "can't be blank", @form_helpers_article.errors.on(:category_ids)
  end
  
    def test_should_fail_with_empty_attributes
  	cheatsheet = Content.new
  	fields = %w{ title description user date permalink version_id }  	
  	assert !cheatsheet.valid?
  	fields.each do |field|  		
  		assert_equal "can't be blank", cheatsheet.errors.on(field.to_sym)
  	end
  end
  
 def test_should_fail_permalink_with_bad_characters
  	bad_permalinks = ["underscore_not_valid", "&no-!weird-%#\"/'characters)$", "no spaces", "NO-CAPITALS"]
  	bad_permalinks.each do |permalink|
  		@form_helpers_article.permalink = permalink
  		assert !@form_helpers_article.valid?
  		assert_equal "is invalid", @form_helpers_article.errors.on(:permalink)
  	 end
  end 
  
  def test_should_succeed_with_valid_permalinks
  	good_permalinks = ["valid-category-name", "rails-2-and-jeffrey", "wembley"]
  	good_permalinks.each do |permalink|
  		@form_helpers_article.permalink = permalink
  		assert @form_helpers_article.valid?, @form_helpers_article.errors.full_messages
  	 end
  end
  
    def test_should_fail_duplicate_permalinks
  	duplicate 			= contents(:file_uploads_tutorial)
  	duplicate.permalink = "debugging-form-helpers-with-the-console"
	assert !duplicate.valid?
  	assert_equal "has already been taken", duplicate.errors.on(:permalink)
  end
  
  def test_should_fail_when_empty_title
 	@form_helpers_article.title = ""
 	assert !@form_helpers_article.valid?
 	assert_equal "can't be blank", @form_helpers_article.errors.on(:title)
  end
  
  def test_should_destroy_dependencies
  	count = @action_mailer_cheatsheet.comments.size
  	count = 0 - count
  	assert_difference('Comment.count',count) do
  		@action_mailer_cheatsheet.destroy
  	end
  end
  
  def test_should_wait_1_hour_before_displaying_new_articles

   assert_difference('Content.recent.count',-1) do 
  		@action_mailer_cheatsheet.date = Time.current
  		@action_mailer_cheatsheet.save!
   end
   
     assert_difference('Content.recent.count') do 
  		@action_mailer_cheatsheet.date = Time.current - 61.minutes
  		@action_mailer_cheatsheet.save!
   end
   
  end
  
  def test_should_have_related_articles
  	 assert_equal @action_mailer_cheatsheet.related_articles.size, 2, "Should have one related article"
  end
  
end
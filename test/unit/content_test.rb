require File.dirname(__FILE__) + '/../test_helper'

class ContentTest < ActiveSupport::TestCase
  
  def test_1_should_fail_with_invalid_version
    article = Factory(:article)
  	article.version_id = 231
  	assert !article.valid?
  	assert_equal 1, article.errors.size, "Should have at least 1 error"
  	assert_equal "does not exist", article.errors[:version]
	assert_equal 1, article.errors.size
  end
  
  def test_2_should_fail_with_empty_category
	article = Factory(:article)	
  	article.categories.destroy_all
  	assert !article.valid?
  	assert_equal "can't be blank", article.errors[:category_ids]
	assert_equal 1, article.errors.size
  end
  
    def test_3_should_fail_with_empty_attributes
  	article = Article.new
  	fields = %w{ title description user date permalink version_id }  	
  	assert !article.valid?
  	fields.each do |field|  		
  		assert_equal "can't be blank", article.errors.on(field.to_sym)
  	end
  end
  
 def test_4_should_fail_permalink_with_bad_characters
	article = Factory(:article)
  	bad_permalinks = ["underscore_not_valid", "&no-!weird-%#\"/'characters)$", "no spaces", "NO-CAPITALS"]
  	bad_permalinks.each do |permalink|
  		article.permalink = permalink
  		assert !article.valid?
  		assert_equal "is invalid", article.errors[:permalink]
		assert_equal 1, article.errors.size
  	 end
  end 
  
  def test_5_should_succeed_with_valid_permalinks
	article = Factory(:article)
  	good_permalinks = ["valid-category-name", "rails-2-and-jeffrey", "wembley"]
  	good_permalinks.each do |permalink|
  		article.permalink = permalink
  		assert article.valid?, article.errors.full_messages
  	 end
  end
  
    def test_6_should_fail_duplicate_permalinks
  	article	  = Factory(:article)
	duplicate = Factory.build(:article, :permalink => article.permalink)
	assert !duplicate.valid?
  	assert_equal "has already been taken", duplicate.errors[:permalink]
	assert_equal 1, duplicate.errors.size
  end
  
  def test_7_should_fail_when_empty_title
 	article = Factory.build(:article, :title => "")
 	assert !article.valid?
 	assert_equal "can't be blank", article.errors[:title]
	assert_equal 1, article.errors.size
  end
  
  def test_8_should_destroy_dependencies
	flunk
  end
  
  def test_9_should_wait_1_hour_before_displaying_new_articles

   assert_difference('Content.recent.count',-1) do 
  		@action_mailer_cheatsheet.date = Time.current
  		@action_mailer_cheatsheet.save!
   end
   
     assert_difference('Content.recent.count') do 
  		@action_mailer_cheatsheet.date = Time.current - 61.minutes
  		@action_mailer_cheatsheet.save!
   end
   
  end
  
  def test_a_should_have_related_articles
  	 flunk
  end
  
end

# == Schema Info
# Schema version: 20090827143534
#
# Table name: contents
#
#  id          :integer(4)      not null, primary key
#  version_id  :integer(4)
#  content     :text
#  date        :datetime
#  description :string(255)
#  has_toc     :boolean(1)
#  permalink   :string(255)
#  title       :string(255)
#  type        :string(255)
#  user        :string(255)
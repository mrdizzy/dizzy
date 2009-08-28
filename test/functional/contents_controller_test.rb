require File.dirname(__FILE__) + '/../test_helper'

class ContentsControllerTest < ActionController::TestCase

  def test_truth
    assert true
  end
  
  def setup
   @article1 = Factory(:article, :date => Time.now)
   @article2 = Factory(:article, :date => 1.day.ago)
   @article3 = Factory(:article, :date => 10.days.ago)
  end
  
  # Index
  
  def test_1_index_administrator
    get :index, {}, { :admin_password => PASSWORD }
	assert_response :success
    	# Categories form 
    assert_select "form[action=\"#{categories_path}\"]", { :count => 1}
    	# Articles
    content = Content.recent
    assert_select "table#article_links" do 
	    content.each do |article|
    		assert_select "h2", /#{article.title}/
    	end
	   assert_select 'a', { :count => content.size, :text => "edit"}
	   assert_select 'a', { :count => content.size, :text => "delete"}
	end
  end
  
 def test_2_index_not_administrator
   get :index
   assert_select "form[action=\"#{categories_path}\"]", false, "There should be no new category form"
 content = Content.recent
    assert_select "table#article_links" do 
	    content.each do |article|
    		assert_select "h2", /#{article.title}/
    	end
	   assert_select "a", {:count => 0, :text => "edit"}
	   assert_select "a", {:count => 0, :text => "delete"}
   end
   assert_response :success
   
 end
 
 	# New
 	
 	def test_3_should_show_new_form_when_administrator
 		get :new, {}, { :admin_password => PASSWORD }
 		assert_response :success
 	end
 	
 	def test_4_should_fail_new_form_when_not_administrator
 		get :new
 		assert_redirected_to login_path
 	end
 	
 	# Edit
 	
 	def test_5_should_show_edit_form_when_administrator
 		get :edit, {:id => @article1.id}, { :admin_password => PASSWORD }
 		assert_response :success
 		assert_select "form[name=edit_form]" 
      assert_select "select#article_category_ids" do 
         assert_select "option[selected=selected]", :count => @article1.categories.size
         @article1.categories.each do |category|
            assert_select "option[selected=selected][value=#{category.id}]"
         end
      end
 	end
 	
 	def test_6_should_fail_edit_form_when_not_administrator
 		get :edit, :id => @article1.id
 		assert_redirected_to login_path
 	end
 	
 	# Show
 	
 	def test_7_should_show_comments_without_administrator
 		get :show, { :id => @article1.permalink }
 	
		@article1.comments.each do |comment|
			assert_select "div#comment_#{comment.id}" do 
				assert_select "h6", comment.subject, "No subject found"
					# Do not show comment email 
				assert_select "span", { :count => 0, :text => comment.email }, "No email found"
				assert_select "p", comment.body, "No body found"
			end		
		end	
 		assert_response :success
 	end
 	
 	def test_8_should_show_comments_administrator
 		get :show, { :id => @article1.permalink }, { :admin_password => PASSWORD }
 		comments = @article1.comments
		comments.each do |comment|
			assert_select "div#comment_#{comment.id}" do 
				assert_select "h6", comment.subject, "No comment subject found"
				assert_select "span.email", { :count => 1, :text => comment.email }
				assert_select "p", comment.body, "No body found"
			end		
		end	
 		assert_response :success
 	end
 	
end
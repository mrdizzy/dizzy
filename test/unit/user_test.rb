require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_should_fail_invalid_username
  	user = users(:mr_dizzy)
  	 bad_usernames = ["hypen-not-valid", "&no-!weird-%#\"/'characters)$", "no spaces", "NOCAPITALS"]
  	bad_usernames.each do |username|
  		user.name = username
  		assert !user.valid?, "User #{username} should be invalid"
  		assert_equal "can only contain letters, numbers and underscores", user.errors.on(:name)
  	 end
  end
 
  def test_should_pass_valid_username
  	user = users(:mr_dizzy)
  	 good_usernames = ["valid_username", "validusername", "valid12user", "davey12"]
  	good_usernames.each do |username|
  		user.name = username
  		assert user.valid?, "User #{username} should be valid"
  	 end
  end  
  
  def user_passwords_should_match
  	user = users[:mr_dizzy]
  	
  	user.password = "world1"
  	user.password_confirmation = "world1"
  	assert user.valid?, "Passwords should be valid"
  	
  	user.password_confirmation = "genifer"
  	assert !user.valid?, "Passwords should be invalid"
  	assert_equal "doesn't match confirmation", user.errors.on(:password)
  end
  
  def should_pass_valid_email
  	flunk
  end
  
  def should_pass_valid_surname
  	flunk
  end
  
  def should_pass_valid_firstname
  	flunk
  end
  
end

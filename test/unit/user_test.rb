require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users

  def test_truth
    assert true
  end

  def test_should_fail_invalid_username
  	user = users(:mr_dizzy)
  	 bad_usernames = ["hypen-not-valid", "&no-!weird-%#\"/'characters)$", "no spaces", "NOCAPITALS"]
  	bad_usernames.each do |username|
  		user.name = username
  		assert !user.valid?, user.errors.full_messages
  		assert_equal "can only contain letters, numbers and underscores", user.errors.on(:name)
  	 end
  end

  def test_should_pass_valid_username
  	user = users(:mr_dizzy)
  	 good_usernames = ["validusername", "valid12user", "davey12"]
  	good_usernames.each do |username|
  		user.name = username
  		assert user.valid?, user.errors.full_messages
  	 end
  end  

  def test_user_passwords_should_match
  	user = users(:mr_dizzy)
  	
  	
  	user.password = "world1"
  	user.password_confirmation = "world1"
  	assert user.valid?, user.errors.full_messages
  	
  	user.password_confirmation = "genifer"
  	assert !user.valid?, user.errors.full_messages
  	assert_equal "doesn't match confirmation", user.errors.on(:password)
  end
  
  def test_should_fail_invalid_email
  	user = users(:mr_dizzy)
  	
  	bad_addresses = ["melinda@@dizzy.co.uk", "jamie@192.34.32.43", "louise@louise", "mr_habadashery@*bloo.com"]
  	bad_addresses.each do |address|
  		user.email = address
  		assert !user.valid?, user.errors.full_messages
  		assert_equal "must be a valid address", user.errors.on(:email)
  	end
  end

  def test_should_pass_valid_email
  	user = users(:mr_dizzy)
  	
  	good_addresses = %w{ melinda@dizzy.co.uk jamie@dizzy.com louise.smith@germany.de mr_lewis@lewis.co.uk  david.pettifer@dizzy.co.uk jamie.han@motif-switcher.com }
  	good_addresses.each do |address|
  		user.email = address
  		assert user.valid?, user.errors.full_messages

  	end
  end
 
  def test_should_pass_valid_name
  	user = users(:mr_dizzy)
  	
  	good_names = %w{ O'Reilly McNamara Hypen-Smith }
  	good_names.each do |name|
  		user.surname = name
  		assert user.valid?, user.errors.full_messages
  		
  		user.firstname = name
  		assert user.valid?, user.errors.full_messages
  	end
  end
  
  def test_should_pass_invalid_surnames
  	user = users(:mr_dizzy)
  	
  	bad_names = %w{ m*csmith mc_smith mc12th June^ Lewis* Al&dreant Duept$ Mo£her Ang"r Leon+ard Al(andr Ge)push de=nver }
  	bad_names.each do |name|
  		user.firstname = name
  		assert !user.valid?,  user.errors.full_messages
  		assert_equal "can only contain letters, apostrophes and hypens", user.errors.on(:firstname)
  		
    	user.surname = name
  		assert !user.valid?,  user.errors.full_messages
  		assert_equal "can only contain letters, apostrophes and hypens", user.errors.on(:surname)		
  	end
  end
  
end
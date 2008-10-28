# == Schema Information
# Schema version: 13
#
# Table name: users
#
#  id              :integer(4)    not null, primary key
#  name            :string(255)   
#  hashed_password :string(255)   
#  salt            :string(255)   
#  firstname       :string(255)   
#  surname         :string(255)   
#  email           :string(255)   
#

class User < ActiveRecord::Base

require 'digest/sha1'
	validates_presence_of :name
	validates_format_of	:name, :with => /^[a-z0-9_]+$/, :message => "can only contain letters, numbers and underscores"
	validates_format_of :surname, :with => /^[a-z'-]+$/i, :message => "can only contain letters, apostrophes and hypens"
	validates_format_of :firstname, :with => /^[a-z'-]+$/i, :message => "can only contain letters, apostrophes and hypens"
	validates_uniqueness_of :name
	validates_confirmation_of :password
	validates_format_of :email, :with => /^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i, :message => "must be a valid address"
	
	def validate
		errors.add_to_base("Missing password" ) if hashed_password.blank?
	end
	
	def self.authenticate(name, password)
		user = self.find_by_name(name)
		if user
			expected_password = encrypted_password(password, user.salt)
			if user.hashed_password != expected_password
				user = nil
			end
		end
		user
	end
	
	# 'password' is a virtual attribute
	def password
		@password
	end
	
	def password=(pwd)
		@password = pwd
		return if pwd.blank?
		create_new_salt
		self.hashed_password = User.encrypted_password(self.password, self.salt)
	end
	
	private
	
	def self.encrypted_password(password, salt)
		string_to_hash = password + "wibble" + salt # 'wibble' makes it harder to guess
		Digest::SHA1.hexdigest(string_to_hash)
	end
	
	def create_new_salt
		self.salt = self.object_id.to_s + rand.to_s
	end
end

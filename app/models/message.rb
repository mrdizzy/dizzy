class Message < ActiveRecord::Base
	attr_accessor :recaptcha_response_field, :recaptcha_challenge_field, :remote_ip
	
	validates_presence_of :email, :name, :message, :recaptcha_response_field
	validates_confirmation_of :email

	def validate
		recaptcha = Net::HTTP.post_form URI.parse("http://api-verify.recaptcha.net/verify"), {
			:privatekey => RECAPTCHA_PRIVATE_KEY,
			:remoteip   => remote_ip,
			:challenge  => recaptcha_challenge_field,
			:response   => recaptcha_response_field
		}
		result =  recaptcha.body
		success,error = result.split("\n")
		errors.add(:recaptcha_response_field, 'was not entered correctly') unless success == "true"
	end
		
end

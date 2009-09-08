require 'digest/md5'

class Message < ActiveRecord::Base
	
	attr_accessor :answer
  attr_reader   :answer_confirmation
	
	validates_presence_of :email, :name, :message, :answer
	validates_confirmation_of :email
	
	after_save :deliver_message

	acts_as_textcaptcha

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
	
	def deliver_message
		Mercury.deliver_new_message(self)
	end
	
	def question
    @question ||= get_question
	end
		
  private  
  
  def get_question
    xml                        = Net::HTTP.get_response(URI.parse("http://textcaptcha.com/api/#{TEXTCAPTCHA}")).body
    response                   = Hash.from_xml(xml)
    @answer_confirmation       = response["captcha"]["answer"] 
    @question                  = response["captcha"]["question"]
  end
  
end

# == Schema Info
# Schema version: 20090827143534
#
# Table name: messages
#
#  id         :integer(4)      not null, primary key
#  email      :string(255)
#  message    :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
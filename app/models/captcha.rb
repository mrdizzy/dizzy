require 'digest/md5'

class Captcha 

	attr_reader :question

	def initialize
		xml         = Net::HTTP.get_response(URI.parse("http://textcaptcha.com/api/#{TEXTCAPTCHA}")).body
		response    = Hash.from_xml(xml)
    
		@question   = response["captcha"]["question"]
		@answer     = response["captcha"]["answer"]
    @answer.each do |answer|
      puts answer
      puts Digest::MD5.hexdigest("Hello World").strip

    end
	end
end
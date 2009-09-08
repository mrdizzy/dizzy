module TextCaptcha

	def self.included(base)
		base.extend(ActMethods)
	end
  
  module ActMethods
  
    def acts_as_textcaptcha
      unless included_modules.include? InstanceMethods
        extend ClassMethods
        include InstanceMethods
      end
    end
    
    module ClassMethods
       ActiveRecord::Base.validates_each :answer do |record, attr, value|
        record.errors.add attr, "is not correct" unless record.answer_confirmation.values.detect { |v| v[:answer_confirmation] == record.encrypted_answer }
       end
    end 
    
    module InstanceMethods
    
      attr_accessor :answer
      attr_accessor :answer_confirmation
      
      def question
        @question ||= get_question
      end
      
      def encrypted_answer
         Digest::MD5.hexdigest(answer)
      end
      
      private
      
      def get_question
        result = Net::HTTP.get(URI.parse("http://textcaptcha.com/api/1l9vs903fvj4coc48cc0gckw8"))
        response_hash = Hash.from_xml(result)
        @answer_confirmation = response_hash["captcha"]["answer"]
        @question            = response_hash["captcha"]["question"]
      end
      
    end
    
  end

end
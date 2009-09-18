module Dizzy
module Cumber
	module FormBuilderddd
			
		def captcha_answer(options = {})
			result = text_field(:answer, options)
			@object.answer_confirmation.each_with_index do |answer, index|
				result << ActionView::Base::InstanceTag.new("#{@object_name}[answer_confirmation]", "", @template, @object).to_input_field_tag("hidden", options.merge(:value => answer))
			end
			result
		end

		def captcha_question(options = {})
			label(:answer, @object.question) +
			hidden_field(:question) 
		end
			
	end
end
end
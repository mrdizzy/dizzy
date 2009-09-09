class CaptchaFormBuilder < ActionView::Helpers::FormBuilder
	
	def captcha_answer(options = {})
		result = text_field(:answer, options)
		@object.answer_confirmation.each_with_index do |answer, index|
			result << ActionView::Base::InstanceTag.new("#{@object_name}[answer_confirmation]", :answer_confirmation, @template, @object).to_input_field_tag("hidden", options.merge(:value => answer, :index => index))
		end
		result
	end
	
	def captcha_question(options = {})
		result = label(:answer, @object.question)
	end
	
end
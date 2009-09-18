class DizzyBuilder < ActionView::Helpers::FormBuilder
	def text_field(method, options = {})
		@template.content_tag("p", label(method) + super)			
	end
end
puts "Included"
ActionView::Base.default_form_builder = DizzyBuilder


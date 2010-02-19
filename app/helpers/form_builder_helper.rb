module FormBuilderHelper

	def form_for_comments(name, *args, &block)
		options = args.extract_options!
		options = options.merge(:builder => DizzyCommentFormBuilder)
		options = options.merge(:html => { :id => "new_comment_#{name.parent_id}" } )
		args = (args << options) 
		form_for(name, *args, &block)
	end	
	
	def submit_button() 	submit_tag('', { :class => 'submit' }) end
end

class DizzyFormBuilder < ActionView::Helpers::FormBuilder

	def self.create_labelled_field(method_name)
		define_method(method_name) do |meth, *args|
			@template.content_tag("p", label(meth) + super(meth, *args))
		end
	end

	(field_helpers - %w(label fields_for hidden_field)).each do |name|
		create_labelled_field(name)
	end

	def datetime_select(meth, *args)
		@template.content_tag("p", label(meth) + super(meth, *args))
	end

	def select(meth, *args)
		@template.content_tag("p", label(meth) + super(meth, *args))
	end

	def collection_select(meth, *args)
		@template.content_tag("p", label(meth,meth.to_s.gsub("_ids","").pluralize.capitalize.humanize) + super(meth, *args))
	end
end

class DizzyCommentFormBuilder < ActionView::Helpers::FormBuilder
	def self.create_labelled_field(method_name)
		define_method(method_name) do |meth, *args|
			options = args.extract_options!
			options = options.merge(:id => "#{object_name}_#{meth}_#{object.parent_id}")
			args = (args << options)
			super(meth, *args)
		end
	end

	def label(meth, text=nil)
		super(meth, text, :for => "#{object_name}_#{meth}_#{object.parent_id}")
	end

	def hidden_field(meth, *args)
		options = args.extract_options!
		options = options.merge(:id => "#{object_name}_#{meth}_#{object.parent_id}")
		args = (args << options)
		super(meth, *args)
	end

	(field_helpers - %w(label fields_for hidden_field)).each do |name|
		create_labelled_field(name)
	end
	
	def submit
		@template.submit_tag("Submit", :id => "#{object_name}_submit_#{object.parent_id}")
	end
end

ActionView::Base.default_form_builder = DizzyFormBuilder

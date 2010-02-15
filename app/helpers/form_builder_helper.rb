module FormBuilderHelper

	def form_for_comments(name, *args, &block)
		options = args.extract_options!
		options = options.merge(:builder => DizzyCommentFormBuilder)
		options = options.merge(:html => { :id => "new_comment_#{name.parent_id}", :style => "display:none;" } )
		args = (args << options) 
		form_for(name, *args, &block)
	end	
	
	def submit_button() 		submit_tag('', { :class => 'submit' });	end
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

	def collection_select(meth, *args)
		@template.content_tag("p", label(meth,meth.to_s.gsub("_ids","").pluralize.capitalize) + super(meth, *args))
	end
end

class DizzyCommentFormBuilder < ActionView::Helpers::FormBuilder
	def self.create_labelled_field(method_name)
		define_method(method_name) do |meth, *args|
			options = args.extract_options!
			options = options.merge(:id => "#{object_name}_#{meth}_#{object.parent_id}")
			args = (args << options)
			@template.content_tag("p", label(meth, nil, :for => "#{object_name}_#{meth}_#{object.parent_id}") + super(meth, *args))
		end
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
end

ActionView::Base.default_form_builder = DizzyFormBuilder
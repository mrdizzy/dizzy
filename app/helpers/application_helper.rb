module ApplicationHelper

    def article_link(object); link_to object.title, content_path(object.permalink); end

	def posted_in(categories, and_connector = true)
		and_connector = and_connector ? "<span class=\"amp\">&asp;</span>" : ", "
		categories.map! { |c| link_to(c.name.upcase, category_path(c.permalink)) }
		result = categories.to_sentence(:last_word_connector => and_connector, :two_words_connector => ", ")
		"<span class=\"posted_in\">" + result + "</span>"
	end

	def location_icon() 	image_tag("f/small_icons/you-are-here.gif", :alt => "You are here:", :size=> "25x24"); end	
	def asterisk() 			image_tag("f/bullets/pixels/asterisk.png", :alt => "*"); end
	def square()			image_tag("f/bullets/pixels/square.png", :alt => "&mdash;"); end
	def bigarrow() 			image_tag("f/bullets/pixels/bigarrow.png", :size=> "17x13", :alt => "->"); end	
	def bigleftarrow() 		image_tag("f/bullets/arrows/bigleftarrow.png", :size => "17x13", :alt => "->"); end		
	def diamond() 			image_tag("f/bullets/pixels/diamond.png", :size=> "5x5", :alt => "*"); end
	def solid_arrow() 		image_tag("f/bullets/arrows/solidarrow.png", :size => "13x9", :alt => ">"); end
	def spiro() 			"<div class=\"spiro\">&nbsp;</div>"; end	
	def visible?(input) 	diamond if input; end 	
		
	def submit_button() 		submit_tag('', { :class => 'submit' });	end
	def get_random_companies() 	Company.all(:order => 'RAND()', :limit => 5); end	
	def random_number(higher=4)	(higher * rand).to_i; end

	def administrator?() 		session[:administrator_id] ? true : false; end
	
	def form_for_comments(name, *args, &block)
		options = args.extract_options!
		options = options.merge(:builder => DizzyCommentFormBuilder)
		options = options.merge(:html => { :id => "new_comment_#{name.parent_id}", :style => "display:none;" } )
		args = (args << options) 
		form_for(name, *args, &block)
	end
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

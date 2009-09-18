# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	def core_front_end_stylesheets
		stylesheet_link_tag("main", :media => "all")
	end
	
    def article_link(object)
    	link_to object.title, content_path(object.permalink)
    end

	def posted_in(categories)
		result = []	
		categories.each do |category|
			result << (link_to category.name.upcase, category_path(category.permalink))
		end
		result = result.to_sentence(:skip_last_comma => true, :connector => "AMPERSAND")
		result = result.gsub("AMPERSAND", "<span class=\"amp\">&amp;</span>")
		"<span class=\"posted_in\">" + result + "</span>"
	end

	# Graphics
	
	def location_icon 
		image_tag("f/small_icons/you-are-here.gif", :alt => "You are here:", :size=> "25x24")
	end
	
	def asterisk
		image_tag("f/bullets/pixels/asterisk.png", :alt => "*")
	end
	
	def square
		image_tag("f/bullets/pixels/square.png", :alt => "&mdash;")
	end
		
	def bigarrow
		image_tag("f/bullets/pixels/bigarrow.png", :size=> "17x13", :alt => "->")
	end	
	
	def bigleftarrow
		image_tag("f/bullets/arrows/bigleftarrow.png", :size=> "17x13", :alt => "->")
	end		
	
	def diamond
		image_tag("f/bullets/pixels/diamond.png", :size=> "5x5", :alt => "*")
	end
	
	def solid_arrow
		image_tag("f/bullets/arrows/solidarrow.png", :size=> "13x9", :alt => ">")
	end
	
	def spiro
		"<div class=\"spiro\"> &nbsp;</div>"
	end
			
	def visible?(input)
		if input 
			diamond
		end
	end 	
		
	# Buttons	
	
	def submit_button
		submit_tag '', { :class => 'submit' } 
	end

	# Footer
	
	def get_random_companies
		@five_random_companies = Company.all(:order => 'RAND()', :limit => 5)
	end	
	
	# Random number
	
	def random_number(higher=4)
		(higher * rand).to_i
	end
	
	# Administration

	def administrator?
		if session[:administrator_id]
			true
		else
			false
		end
	end	

end

class DizzyFormBuilder < ActionView::Helpers::FormBuilder

	def self.create_labelled_field(method_name)
		define_method(method_name) do |meth, *args|
			@template.content_tag("p", label(meth) + super(meth, *args))
		end
	end

	(field_helpers - %w(label fields_for)).each do |name|
		create_labelled_field(name)
	end
	
	def datetime_select(meth, *args)
		@template.content_tag("p", label(meth) + super(meth, *args))
	end
	
	def collection_select(meth, *args)
		@template.content_tag("p", label(meth) + super(meth, *args))
	end
end

ActionView::Base.default_form_builder = DizzyFormBuilder


# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	def markdown(text)
	BlueCloth::new(text).to_html
end

def textilize(text)
	 textilized = RedCloth.new(text)
            textilized.to_html
end

def parse_coderay(text)
	
	 text.scan(/(<code\:([a-z].+?)>(.+?)<\/code>)/m).each do |match|
	 	puts match[0]
      text.gsub!(match[0],"<notextile>" + CodeRay.scan(match[2], match[1].to_sym).div(  :css => :class) + "</notextile>")
   		end
   		
   		return text
end
	

	def get_random_companies
		@five_random_companies = Company.find(:all, :order => 'RAND()', :limit => 5)
	end
	def spiro 
		"<div class=\"spiro\">" + image_tag("f/branding/spirosmall.png", :size=> "29x29", :alt => "---") + 
		"</div"
	end
	
	def submit_button
			submit_tag '', { :class => 'submit' } 
	end
	def bigarrow
		image_tag("f/bullets/pixels/bigarrow.png", :size=> "17x13", :alt => "->")
	end	
	def diamond
		image_tag("f/bullets/pixels/diamond.png", :size=> "5x5", :alt => "*")
	end
		def asterisk
		image_tag("f/bullets/pixels/asterisk.png", :size=> "13x13", :alt => "*")
	end
	def visible?(input)
		if input 
			diamond
		end
	end 
	
end

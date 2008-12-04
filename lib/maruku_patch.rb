module MaRuKu 
	module Out
		module HTML
	
			def to_html_code; 
				source = self.raw_code
		
				lang = self.attributes[:lang] || @doc.attributes[:code_lang] 
		
				lang = 'xml' if lang=='html'
		
				use_syntax = get_setting :html_use_syntax
				
				element = 
				if use_syntax && lang
					begin
						if not $syntax_loaded
							require 'rubygems'
							require 'syntax'
							require 'syntax/convertors/html'
							$syntax_loaded = true
						end
						convertor = Syntax::Convertors::HTML.for_syntax lang
						
						# eliminate trailing newlines otherwise Syntax crashes
						source = source.gsub(/\n*\Z/,'')
						
						html = convertor.convert( source )
						html = html.gsub(/\&apos;/,'&#39;') # IE bug
						html = html.gsub(/'/,'&#39;') # IE bug
			#			html = html.gsub(/&/,'&amp;') 
						html = "<pre>" + CodeRay.scan(source, lang.to_sym).html + "</pre>"
						code = Document.new(html, {:respect_whitespace =>:all}).root
						code.name = 'code'
						code.attributes['class'] = 'ruby'
						#code.attributes['lang'] = lang
						
						pre = Element.new 'pre'
						pre << code
						pre
					rescue LoadError => e
						maruku_error "Could not load package 'syntax'.\n"+
							"Please install it, for example using 'gem install syntax'."
						to_html_code_using_pre(source)	
					rescue Object => e
						maruku_error"Error while using the syntax library for code:\n#{source.inspect}"+
						 "Lang is #{lang} object is: \n"+
						  self.inspect + 
						"\nException: #{e.class}: #{e.message}\n\t#{e.backtrace.join("\n\t")}"
						
						tell_user("Using normal PRE because the syntax library did not work.")
						to_html_code_using_pre(source)
					end
				else
					to_html_code_using_pre(source)
				end
				
				color = get_setting(:code_background_color)
				if color != Globals[:code_background_color]
					element.attributes['style'] = "background-color: #{color};"
				end
				add_ws element
			end	
		end
	end
end
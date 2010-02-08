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
					
						
	# eliminate trailing newlines otherwise Syntax crashes
						source = source.gsub(/\n*\Z/,'')

						#html = convertor.convert( source )
						#html = html.gsub(/\&apos;/,'&#39;') # IE bug
						#html = html.gsub(/'/,'&#39;') # IE bug
			#			html = html.gsub(/&/,'&amp;') 
						html = "<pre>" + CodeRay.scan(source, lang.to_sym).html + "</pre>"
						code = Document.new(html, {:respect_whitespace =>:all}).root

						code.attributes['class'] = lang

						code.name = 'code'
						#code.attributes['lang'] = lang

						pre = Element.new 'pre'
						pre << code
						pre
					
				else
					to_html_code_using_pre(source)
				end
				
				color = get_setting(:code_background_color)
				if color != Globals[:code_background_color]
					element.attributes['style'] = "background-color: #{color};"
				end
				add_ws element
			end	
			
			def render_footnotes()
				div = Element.new 'div'				
				div.attributes['class'] = 'footnotes'
				header = Element.new 'h1'
				header << Text.new('Footnotes')
				div << header 
					ol = Element.new 'ol'
					@doc.footnotes_order.each_with_index do |fid, i| num = i+1
						f = self.footnotes[fid]
						if f
							li = f.wrap_as_element('li')
							li.attributes['id'] = "#{get_setting(:doc_prefix)}fn:#{num}"
							
							a = Element.new 'a'
								a.attributes['href'] = "\##{get_setting(:doc_prefix)}fnref:#{num}"
								a.attributes['rev'] = 'footnote'
								a.attributes['class'] = 'footnote_up'
								a<< Text.new('Up', true, nil, true)
							li.insert_after(li.children.last, a)
							ol << li
						else
							maruku_error "Could not find footnote id '#{fid}' among ["+
							 self.footnotes.keys.map{|s|"'"+s+"'"}.join(', ')+"]."
						end
					end
				div << ol
				div
			end
		end
	end
end
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	def get_random_companies
		@five_random_companies = Company.find(:all, :order => 'RAND()', :limit => 5)
	end

	# Graphics
	###########################
	def submit_button
			submit_tag '', { :class => 'submit' } 
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
	
	def asterisk
		image_tag("f/bullets/pixels/asterisk.png", :size=> "13x13", :alt => "*")
	end
	
	def spiro
		"<div class=\"spiro\">" + image_tag("f/branding/spirosmall.png", :size=> "29x29", :alt => "---") + 
		"</div>"
	end
	
	def visible?(input)
		if input 
			diamond
		end
	end 	

	def posted_in(categories)
		result = []		
		categories.each do |category|
			result <<
		 (link_to category.name, {:controller => :content, :action => :articles_for_category, :permalink => category.permalink })
	end
	"<span class=\"blue_bold\">Posted in</span> " + diamond + " " + result.to_sentence(:skip_last_comma => true)
	end
	
	def parse_cheatsheet_xml(xml)
		require 'rexml/parsers/pullparser'
		parser = REXML::Parsers::PullParser.new( xml)
		results =[]
		tag_stack = []
		row_stack = []
		counter_stack = []
		counter = 0
		row_cycle = 0
		break_counter = 0
		
		while parser.has_next?
			pull_event = parser.pull
			raise pull_event[1] if pull_event.error?
			case pull_event.event_type
				when :start_element
		    	
		      	tag_stack.push "h1" if pull_event[0] == "title"
		      	tag_stack.push "code" if pull_event[0] == "c"
		      	tag_stack.push "h2" if pull_event[0] == "subhead"
		      	tag_stack.push "h3" if pull_event[0] == "minihead"
		      	tag_stack.push "h3" if pull_event[0] == "h3"
		      	tag_stack.push "ruby" if pull_event[0] == "r"
		      	tag_stack.push "rhtml" if pull_event[0] == "rh"
		       	tag_stack.push "ul" if pull_event[0] == "ul"
		        tag_stack.push "li" if pull_event[0] == "li"
		      	tag_stack.push "td" if pull_event[0] == "Cell"
		      	tag_stack.push "table" if pull_event[0] == "Table"
		      	tag_stack.push "div" if pull_event[0] == "article"
		       	tag_stack.push "p" if pull_event[0] == "p"
				if pull_event[0] == "subhead"
					
					if break_counter > 1
						results << "<h2 class=\"break\">"
					else
						results << "<h2>"
					end
				break_counter = break_counter + 1
				elsif pull_event[0] == "img"
					image_id = pull_event[1]['src']
					results << "<img src=\"/binaries/get/#{image_id}\" />"				
				elsif pull_event[0] == "article"
					results << "<div id=\"article\">"				
				elsif pull_event[0] == "Cell"
					if counter_stack.last == row_stack.last					
						results << "<td>"
						counter = counter_stack.last - 1
						counter_stack.pop
						counter_stack.push counter
					elsif counter_stack.last == 0 		
						row_cycle = row_cycle + 1
						if row_cycle.odd?
							results << "</tr><tr class=\"odd\">"
						else
							results << "</tr><tr>"
						end
						results << "<td>"
						counter = counter_stack.last - 1
						counter_stack.pop
						counter_stack.push(row_stack.last - 1)
					else
						counter = counter_stack.last - 1
						counter_stack.pop
						counter_stack.push counter
						results << "<td>"
					end					
					
	       		elsif pull_event[0] == "Table"	       			
	       			row_stack.push pull_event[1]["aid:tcols"].to_i
	       			counter_stack.push row_stack.last
	       			results << "<table><tr>"	       		
       			elsif pull_event[0] == "method_odd"
       				tag_stack.push "div"
		       		results << "<div class=\"odd\">"
	       		elsif pull_event[0] == "directory_structure"
	       			tag_stack.push "ul"
	       			results << "<ul class=\"directory\">"
	       		else	       			
		      		results << "<#{tag_stack.last}>" if tag_stack.size > 0 && tag_stack.last != "ruby"
	      		end
		    when :text
		    	if tag_stack.last == "ruby"
		    		results << parse_coderay(pull_event[0], :ruby)	 
		    	elsif tag_stack.last == "rhtml"
		    		results << parse_coderay(pull_event[0], :rhtml)     		
	      		else	
		    		results << pull_event[0]   
	      		end 
		    when :end_element
		    	if pull_event[0] == "Table"
		    	 	results << "</tr>" 
		    	 	row_stack.pop 
				    counter_stack.pop 
				    row_cycle = 0 
				end
		    	results << "</#{tag_stack.pop}>"   if tag_stack.size > 0 && tag_stack.last != "ruby"
		      	tag_stack.pop if tag_stack.last == "ruby"		      	
		  	end
		end
		return results.join		
	end		
		def markdown(text)
		BlueCloth::new(text).to_html
	end
		
	def prepare_comments(comments,result=Array.new,counter=0)
		counter = counter + 1
		comments.each do |comment|			
			if counter.even?
			result << "<div class=\"odd\" id=\"comment_#{comment.id}\">"
			else
				result << "<div class=\"normal\" id=\"comment_#{comment.id}\">"
			end
			result << "<span class=\"date\">#{comment.created_at.to_s(:long)}</span> " + diamond + " <b>#{comment.subject}</b><p>#{comment.body}</p><div id=\"reply_#{comment.id}\">" + link_to_remote("Reply",{ :url => { :action => "reply", :id => comment.id} })  + "</div>"
						
				prepare_comments(comment.children,result,counter) unless comment.children.empty?
						
			result << "</div>"
		end
		result		
	end
	
	def textilize(text)
		 textilized = RedCloth.new(text).to_html
	end
	
	def parse_coderay(text, language)	
	 	text.gsub!(/&lt;/, '<')
	 	text.gsub!(/&gt;/, '>')
	 	text.gsub!(/&amp;/, '&')
	 	text.gsub!(/&quot;/, '"')
	 	
	   	CodeRay.scan(text, language).div( :line_numbers => :inline, :css => :class)	   	
	end
	
end

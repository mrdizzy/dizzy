module CheatsheetsHelper
	
	def parse_cheatsheet_xml(xml)
		require 'rexml/parsers/pullparser'
		parser = REXML::Parsers::PullParser.new( xml)
		results =[]
		tag_stack = []
		
		while parser.has_next?
		  pull_event = parser.pull
		  raise pull_event[1] if pull_event.error?
		  case pull_event.event_type
		    when :start_element
		    	
		      tag_stack.push "h1" if pull_event[0] == "title"
		      tag_stack.push "code" if pull_event[0] == "inline_code"
		      tag_stack.push "h2" if pull_event[0] == "subhead"
		      tag_stack.push "h3" if pull_event[0] == "minihead"
		      tag_stack.push "ruby" if pull_event[0] == "ruby"
		       tag_stack.push "p" if pull_event[0] == "content"
		       tag_stack.push "div" if pull_event[0] == "method:odd"
		       
		       if pull_event[0] == "method:odd"
		       		results << "<div class=\"odd\">"
	       		else
		      		results << "<#{tag_stack.last}>" if tag_stack.size > 0
	      	end
		      when :text
		    		if tag_stack.last == "ruby"
		      			results << parse_coderay(pull_event[0])
		      			puts "yes #{pull_event[0]}"
	      			else	
		      			results << pull_event[0]   
	      			end 
		    when :end_element
		      results << "</#{tag_stack.pop}>"   if tag_stack.size > 0 && tag_stack.last != "ruby"
		     tag_stack.pop if tag_stack.last == "ruby"
		      results << "<hr/>" if pull_event[0] == "subhead" 
		     
		  end
		end
		return results
	end
	
end

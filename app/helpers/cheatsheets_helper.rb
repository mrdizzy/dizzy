module CheatsheetsHelper
	
	def parse_cheatsheet_xml(xml)
		require 'rexml/parsers/pullparser'
		parser = REXML::Parsers::PullParser.new( xml)
		results =[]
		tag_stack = []
		row_stack = []
		counter_stack = []
		counter = 0
		row_cycle = 0
		
		while parser.has_next?
		  pull_event = parser.pull
		  raise pull_event[1] if pull_event.error?
		  case pull_event.event_type
		    when :start_element
		    	
		      tag_stack.push "h1" if pull_event[0] == "title"
		      tag_stack.push "code" if pull_event[0] == "code"
		      tag_stack.push "h2" if pull_event[0] == "subhead"
		      tag_stack.push "h3" if pull_event[0] == "minihead"
		      tag_stack.push "ruby" if pull_event[0] == "ruby"
		       tag_stack.push "ul" if pull_event[0] == "ul"
		        tag_stack.push "li" if pull_event[0] == "li"
		      tag_stack.push "td" if pull_event[0] == "Cell"
		      puts pull_event[0]
		      tag_stack.push "table" if pull_event[0] == "Table"
		       tag_stack.push "p" if pull_event[0] == "p"

				if pull_event[0] == "Cell"
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
						counter_stack.push (row_stack.last - 1)
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
	       			
		      		results << "<#{tag_stack.last}>" if tag_stack.size > 0
	      	end
		      when :text
		    		if tag_stack.last == "ruby"
		      			results << parse_coderay(pull_event[0])	      			
	      			else	
		      			results << pull_event[0]   
	      			end 
		    when :end_element
		    	 results << "</tr>" if pull_event[0] == "Table"
		      results << "</#{tag_stack.pop}>"   if tag_stack.size > 0 && tag_stack.last != "ruby"
		      tag_stack.pop if tag_stack.last == "ruby"
		     
		      results << "<hr/>" if pull_event[0] == "subhead" 
		      
		      row_stack.pop if pull_event[0] == "Table"
		      counter_stack.pop if pull_event[0] == "Table"
		      row_cycle = 0 if pull_event[0] == "Table"
		     
		  end
		end
		return results.join		
	end	
end

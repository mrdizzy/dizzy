module ContentHelper

	include REXML	
	
	class Listener
		
		TAGS = { "title" => "h1", "c" => "code", "article" => "div"}	  
		
		TEXT_METHODS = { "r" => "1", "rnum" => "1", "rh" => "1", "rhnum" => "1"}	
		TAG_METHODS = {"Table" => "1", "Cell" => "1", "directory_structure"=> 1, "sample_code"=>1, "minihead" => 1, "subhead" => 1	}	
		@@TABLES = Array.new
		@@RESULT = Array.new	  
		@@STACK = []	
		@@TEXT_METHODS_STACK = []	
	  	@@counter = 0
	  	
	  	def results
	  		result = @@RESULT.to_s
	  		TAG_METHODS.each_key do |key|
				result = result.gsub("<#{key}", "")
				result = result.gsub("</#{key}>", "")
			end
			TEXT_METHODS.each_key do |key|
				result = result.gsub("<#{key}>", "")
				result = result.gsub("</#{key}>", "")
			end
			result
  		end
	  		
		# Determine action
		
		def method_missing(method_name, *args)
		
			(name,attributes) = args
			
			case method_name
				when :text
					if @@TEXT_METHODS_STACK.last
				 		@@RESULT << send(@@TEXT_METHODS_STACK.last.downcase, name)
			 			@@TEXT_METHODS_STACK.pop
		 			else
		 				@@RESULT << REXML::Text.normalize(name)
	 				end
				 	
				when :tag_start				
					@@STACK << name					
					if TAG_METHODS[name]						
						@@RESULT << send(name.downcase, method_name, name, attributes)	
			 		elsif TAGS[name] 
					 	@@RESULT << "<#{TAGS[name]}>"
					 	@@TEXT_METHODS_STACK << name if TEXT_METHODS[name]
					else
						@@RESULT << "<#{name}>"
						@@TEXT_METHODS_STACK << name if TEXT_METHODS[name]
					end
					
				when :tag_end
					if TAG_METHODS[name]					
						@@RESULT << send(name.downcase, method_name, name, attributes) 
					elsif TAGS[name] 
						 @@RESULT << "</#{TAGS[name]}>"
					else
						@@RESULT << "</#{name}>"
					end					
				end							
		end
			# Text Nodes
			
		def r(text)			
			code = parse_coderay(text, :ruby, "none")							
		end
		
		def rhnum(text)
			code = parse_coderay(text, :rhtml, "inline")					
		end
		
		def rnum(text)
			code = parse_coderay(text, :ruby, "inline")					
		end		
		
		def rh(text)
			code = parse_coderay(text, :rhtml, "none")			
		end
			# List nodes
		def directory_structure(method_name,text,attributes)
			case method_name
			when :tag_start
				"<ul class=\"directory\">"
			when :tag_end
				"</ul>"
			end
		end
			# Other nodes
			
		def minihead(method_name,text,attributes)
			result = String.new
			case method_name		
			when :tag_start
				@@counter = @@counter + 1
				result = "</div>" unless @@counter == 1
				if @@counter.even?
					result += "<div id=\"method\" class=\"blue\"><h3>" 
				else
					result += "<div id=\"method\"><h3>"
				end
			when :tag_end
				result = "</h3>"
			end
			result
		end			
		
		def subhead(method_name,text,attributes)	
				
			case method_name		
			when :tag_start
				if @@counter > 0 and @@counter.even?
					@@counter = 0
					"</div><h2>"					
				else
					@@counter = 0
					"<h2>"
				end
			when :tag_end
				"</h2>"
			end
			
		end
			# Table Routines
			
		def sample_code(method_name,text,attributes)			
			case method_name
			when :tag_start
				start_table_tag(attributes['aid:tcols'].to_i,"sample_code")
			when :tag_end
				end_table_tag
			end
		end			
		
		def table(method_name,text,attributes)			
			case method_name
			when :tag_start
				start_table_tag(attributes['aid:tcols'].to_i,nil)
			when :tag_end
				end_table_tag
			end
		end
		
		def start_table_tag(columns, css_class)
				@@TABLES.push({ :columns => columns,  :column_counter => columns, :row_counter => 0 })	
				if css_class
					"<table class=\"#{css_class}\">"
				else
					"<table>"
				end
		end
		
		def end_table_tag
			@@TABLES.pop
			"</table>"
		end	
		
		def cell(method_name,text,attributes)
			case method_name
			when :tag_start
				if new_table_row?
					decrement_table	
					"<td class=\"first\">"
				else
					decrement_table	
					"<td>"
				end		
					
			when :tag_end
				end_table_row?	
				"</td>"
			end	
		end		
				
		def decrement_table
			@@TABLES.last[:column_counter] = @@TABLES.last[:column_counter] - 1			
		end	
		
		def reset_table_column_counter
			@@TABLES.last[:column_counter] = @@TABLES.last[:columns]
		end
		
		def end_table_row?
			if @@TABLES.last[:column_counter] == 0		
				@@RESULT << "</tr>"
				reset_table_column_counter	
			end
		end
		
		def new_table_row?
			if @@TABLES.last[:column_counter] == @@TABLES.last[:columns]
				@@TABLES.last[:row_counter] = @@TABLES.last[:row_counter] + 1
				if @@TABLES.last[:row_counter].even?
					@@RESULT << "<tr class=\"odd\">"
				else
					@@RESULT << "<tr>"
				end
				"new"
			end
		end
		
		# Syntax Highlighting		
		def parse_coderay(text, language, line_numbers)		
			result = "<pre class=\"CodeRay\">"
		 	result += CodeRay.scan(text, language).html	
	 	   	result += "</pre>"
	 	  	result
		end					
	end
	
	def parse_cheatsheet_xml(xml)
		
		# InDesign creates each separate line of code as a paragraph, we have to convert this into newlines
		# to avoid double-spacing the code 
		
		xml = xml.gsub("</rh><rh>", "\n") 
			xml = xml.gsub("</r><r>", "\n") 	
		listener = Listener.new
		parser = Parsers::StreamParser.new(xml, listener)
		parser.parse
		xml = listener.results		
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

	def pdf_thumbnail(content)
		"<p class=\"center\">" + image_tag("/thumbnails/#{content.permalink}.png") + "</p>"
	end
end

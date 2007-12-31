module ContentHelper

	include REXML	
	
	class Listener
		include ApplicationHelper
		TAGS = { "title" => "h1", "c" => "code", "article" => "div"}	  
		
		TEXT_METHODS = { "r" => "1", "rnum" => "1", "rh" => "1", "rhnum" => "1"}	
		TAG_METHODS = {"Table" => "1", "Cell" => "1", "sample_code"=>1, "minihead" => 1, "subhead" => 1	}	
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
					 	@@RESULT << "<#{TAGS[name]}"
					 	attributes.each_pair do |key,value|
					
					 		@@RESULT << " #{key}=\"#{value}\""
				 		end
				 		@@RESULT << ">"
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
		
			#Ordered lists
		xml = xml.gsub("</ol><ol>", "</li><li>")
		xml = xml.gsub("<ol>", "<ol><li>")
		xml = xml.gsub("</ol>", "</li></ol>")
		
		# Nested lists
		xml = xml.gsub("</ul2><ul3>", "</li><boo><li>")
		xml = xml.gsub("</ul3><ul3>", "</li><li>")
		xml = xml.gsub("</ul3><ul>", "</li></bam></ul><li>")
		xml = xml.gsub("</ul><ul2>", "</li><boo><li>")
		xml = xml.gsub("</ul2><ul2>", "</li><li>")
		xml = xml.gsub("</ul3><ul2>", "</li></bam><li>")
		xml = xml.gsub("</ul2><ul>", "</li></bam><li>")
		xml = xml.gsub("<ul>", "<ul><li>")
			xml = xml.gsub("</ul>", "</li></ul>")
		xml = xml.gsub("<boo>", "<ul>")
			xml = xml.gsub("</bam>", "</ul>")
		xml = xml.gsub("</ul2>", "</li></ul></ul>")
		xml = xml.gsub("</ul3>", "</li></ul></ul></ul>")
		puts xml
		listener = Listener.new
		parser = Parsers::StreamParser.new(xml, listener)
		parser.parse
		xml = listener.results		
	end

	def pdf_thumbnail(content)
		"<div class=\"cheatsheet_thumbnail\">" + image_tag("/thumbnails/#{content.permalink}.png") + "</div>"
	end
end

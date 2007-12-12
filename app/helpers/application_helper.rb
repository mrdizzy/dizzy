# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

    def article_link(object)
    	link_to object.title, { :controller => :content, :action => :show, :permalink => object.permalink }
    end

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
	
	def solid_arrow
		image_tag("f/bullets/arrows/solidarrow.png", :size=> "13x9", :alt => ">")
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

	class ContentParser
		 require 'rexml/document'
		 include REXML
		require 'enumerator'
	
	@@TAGS = { "title" => "h1", "c" => "code", "subhead" => "h2", "minihead" => "h3", "r" => "ruby", "rnum" => "rubynum", "rh" => "rhtml", "rhnum"=> "rhtmlnum", "article" => "div", }
	
		 attr_accessor :xml
		 def parse_doc
		 	doc = Document.new(@xml)
		 	@@TAGS.each_pair do |key, value|	 	
		 		doc.root.elements.each("//#{key}") do |element|
		 			element.name = value
		 		end
	 		end
		 	doc.root.elements.each("//sample_code") do |table|
		 		parse_table(table,"sample_code")
	 		end
	 		doc.root.elements.each("//Table") do |table|
		 		parse_table(table, nil)
	 		end
	 		doc.root.elements.each("//ruby") do |ruby|
	 			code = Document.new(parse_coderay(ruby.text, :ruby, "none"))
	 			ruby.parent.replace_child(ruby, code)		
 			end
 			doc.root.elements.each("//rubynum") do |ruby|
	 			code = Document.new(parse_coderay(ruby.text, :ruby, :inline))	
	 			ruby.parent.replace_child(ruby, code)			
 			end
	 		doc		
	     end
	 
	 	 def parse_table(table, css_class)
	 	 	columns 		= table.attributes["aid:tcols"].to_i
			cells			= []
			counter		= 1
			table.name = "table"
			table.attributes["class"] = css_class
	 	 	table.each { |cell| cells << cell }
	 	 	cells.each_slice(columns) do |row|
	 	 		counter = counter + 1
	 	 		tr = Element.new("tr")
	 	 		tr.attributes["class"] = "odd" if counter.odd?
	 	 		table << tr
	 	 		row.each do |cell|
	 	 			cell.name = "td"	 	 		
	 	 			tr << cell
	 	 		end
	 	 	end	
	 	 end
	 	 
	def parse_coderay(text, language, line_numbers)	
	 	text.gsub!(/&lt;/, '<')
	 	text.gsub!(/&gt;/, '>')
	 	text.gsub!(/&amp;/, '&')
	 	text.gsub!(/&quot;/, '"')
	 	if line_numbers == "inline"
	   		CodeRay.scan(text, language).div( :line_numbers => :inline, :css => :class)	
	   	else 
	   		CodeRay.scan(text, language).div( :css => :class)	
	   	end   	
	end
	
	end
	
	def parse_cheatsheet_xml(xml)
		@document = ContentParser.new
		@document.xml = xml		
		@document.parse_doc
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
end

class ContentParser
	 require 'rexml/document'
	 include REXML
	require 'enumerator'

@@TAGS = { "b" => "bold", "h1" => "main_header"}

	 attr_accessor :xml
	 def parse_doc
	 	doc = Document.new(@xml) 	 	
	 	doc.each_element do |element| 
	 		parse_element(element)
 		end
		puts doc
     end
     
	 def parse_element(elements)	
	 	elements.each_element do |element|	 	
	 		element.name=@@TAGS[element.name] if @@TAGS[element.name]
	 		if element.name == "Table"
	 			parse_table(elements,element)
 			else
	 			parse_element(element) 
 			end			
 		end
 	 end
 	 
 	 def parse_table(parent,table)
 	 	columns 		= table.attributes["aid:tcols"].to_i
		cells			= []
		table.name = "table"
 	 	table.each { |cell| cells << cell }
 	 	cells.each_slice(columns) do |row|
 	 		tr = Element.new("tr")
 	 		table << tr
 	 		row.each do |cell|
 	 			cell.name = "td"
 	 			tr << cell
 	 		end
 	 	end	
 	 end
end
@document = ContentParser.new

@document.xml = "<root><h1>Hi my name is <b>David</b>. Thank you for saying hi</h1><Table xmlns:aid=\"http://ns.adobe.com/AdobeInDesign/4.0/\" aid:table=\"table\" aid:trows=\"2\" aid:tcols=\"2\"><Cell aid:table=\"cell\" aid:crows=\"1\" aid:ccols=\"1\" aid:ccolwidth=\"27.6290601173522\">Code:</Cell><Cell aid:table=\"cell\" aid:crows=\"1\" aid:ccols=\"1\" aid:ccolwidth=\"232.158341457451\"><r>text_field( :post, :title, :size =&gt; 20, :class =&gt; &quot;blue&quot; )</r></Cell><Cell aid:table=\"cell\" aid:crows=\"1\" aid:ccols=\"1\" aid:ccolwidth=\"27.6290601173522\">Output:</Cell><Cell aid:table=\"cell\" aid:crows=\"1\" aid:ccols=\"1\" aid:ccolwidth=\"232.158341457451\"><r>&lt;input type=&quot;text&quot; id=&quot;post_title&quot; name=&quot;post[title]&quot; size=&quot;20&quot; value=&quot;\#{@post.title}&quot; class=&quot;blue&quot; /&gt;</r></Cell></Table><Table xmlns:aid=\"http://ns.adobe.com/AdobeInDesign/4.0/\" aid:table=\"table\" aid:trows=\"2\" aid:tcols=\"2\"><Cell aid:table=\"cell\" aid:crows=\"1\" aid:ccols=\"1\" aid:ccolwidth=\"27.6290601173522\">Code:</Cell><Cell aid:table=\"cell\" aid:crows=\"1\" aid:ccols=\"1\" aid:ccolwidth=\"232.158341457451\"><r>text_field( :post, :title, :size =&gt; 20, :class =&gt; &quot;blue&quot; )</r></Cell><Cell aid:table=\"cell\" aid:crows=\"1\" aid:ccols=\"1\" aid:ccolwidth=\"27.6290601173522\">Output:</Cell><Cell aid:table=\"cell\" aid:crows=\"1\" aid:ccols=\"1\" aid:ccolwidth=\"232.158341457451\"><r>&lt;input type=&quot;text&quot; id=&quot;post_title&quot; name=&quot;post[title]&quot; size=&quot;20&quot; value=&quot;\#{@post.title}&quot; class=&quot;blue&quot; /&gt;</r></Cell></Table></root>"

@document.parse_doc
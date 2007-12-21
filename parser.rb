class ContentParser
	 require 'rexml/document'
	 include REXML
	require 'enumerator'

	 attr_accessor :xml
	
	 def parse_doc
	 	doc = Document.new(@xml)
	 	 	
		doc.root.elements.each("//*") do |element|						
			send("#{element.name}", element)
		end 
	
		puts doc
     end
     
	def method_missing(methodname, *args)
 	end
 	
	def pd(element)
		element.name = "Paragraph"
	end
    def table(table)
    	columns 	= table.attributes["aid:tcols"].to_i
		cells		= []
		counter		= 1
		table.name = "table"
		table.elements.to_a("cell").each_slice(columns) do |row|
	 	 		counter = counter + 1
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

@document.xml = "<html><head><title>Title</title></head><body><h1>Article</h1><p>Introduction to article, <b>with part in bold</b></p>.<table aid:tcols=\"2\"><cell>red</cell><cell>orange</cell><cell>yellow</cell><cell>green</cell><cell>blue</cell><cell>indigo</cell><cell>violent</cell></table></body></html>"

@document.parse_doc
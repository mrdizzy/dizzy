module PortfolioHelper
	
	def portfolio_table(company)			
		
		portfolio_items = PortfolioItem.find_all_by_company_id(company, :conditions => 
    	"portfolio_types.visible = '1'", :include => "portfolio_type" )

		portfolio_table = portfolio_items.collect { |p| ["<img src=\"/binaries/portfolio_image/#{p.id}.png\">", p.portfolio_type.column_space, "<img src=\"/binaries/portfolio_type/#{p.portfolio_type.id}\" alt=\"#{p.portfolio_type.description}\" />"]}

		table = TableParser.new(portfolio_table, {:columns => 3}, :class=> "portfolio_table")
		table.parse
	end
	
	class TableParser
		
		def initialize(cells, options={}, html_options={})
			@cells 			= cells
			@table_columns 	= options[:columns]
			@html_options	= html_options
			@counter		= 0 
			@result 		= []
			@header	= []
		end

		def parse
			table_start_tag
	
			@cells.each_with_index do |cell,index|				
				(content,current_cell_column_span,header) 	= cell
			
				new_row?
				
				@counter 				= @counter + current_cell_column_span
				next_cell_column_span 	= peek_next(index)				
									
				if @counter < @table_columns
														
					evaluate_row_span		= @counter + next_cell_column_span  

					if (evaluate_row_span > @table_columns) or (cell == @cells.last)

						adjusted_cell_column_span = @table_columns - @counter + current_cell_column_span
						
						@result << "<td colspan=\"#{adjusted_cell_column_span}\">" + header + "</td>" 
						@result << "</tr>"					
						
						# Header
						
						@header << "<td colspan=\"#{adjusted_cell_column_span}\">" + content + "</td>" 
						@header << "</tr>"
						
						@result << @header
						@header = []
						reset_counter				
						
						next
						
					end
				end
								
				if (@counter == @table_columns)
	
					@result << "<td colspan=\"#{current_cell_column_span}\">" + header + "</td>" 
					@result << "</tr>"
					@header << "<td colspan=\"#{current_cell_column_span}\">" + content + "</td>" 
					@header << "</tr>"
					@result << @header
					@header = []
					reset_counter
					next
					
				else				
					@result << "<td colspan=\"#{current_cell_column_span}\">" + header + "</td>" 
					@header << "<td colspan=\"#{current_cell_column_span}\">" + content + "</td>" 		
				end
				
			end
			table_end_tag
			@result
		end
				
		def peek_next(index)
			if @cells[index+1]
				next_cell = @cells[index+1]
				next_cell = next_cell[1]
			else
				next_cell = 0
			end			
			next_cell
		end
		
		def reset_counter
			@counter = 0
		end
		
		def new_row?
			@result << "<tr>" if @counter == 0 
			@header << "<tr>" if @counter == 0
		end
		
		def table_start_tag
			if @html_options.nil?
				@result << "<table>"
			else 
				@result << "<table"
				@html_options.each_pair do |key,value|
					@result << " #{key}=\"#{value}\""
				end
				@result << ">"
			end
		end
		
		def table_end_tag
			@result << "</table>"
		end
	end
	

end

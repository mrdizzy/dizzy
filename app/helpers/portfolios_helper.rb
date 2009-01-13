module PortfoliosHelper
	
	def portfolio_table(columns=3)	
		
		portfolio_items = @company.portfolio_items_for_display

		portfolio_table = portfolio_items.collect { |p| [ image_tag(formatted_portfolio_item_path(p.id, :png)), p.portfolio_type.column_space, diamond + " " + image_tag(formatted_portfolio_type_path(p.portfolio_type.id,:png))]}

		table(portfolio_table, {:columns => columns}, :class=> "portfolio_table")
	end
	
end

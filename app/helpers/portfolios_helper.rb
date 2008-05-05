module PortfoliosHelper
	
	def portfolio_table	
		
		portfolio_items = PortfolioItem.find_all_by_company_id(@company.id, :conditions => 
    	"portfolio_types.visible = '1'", :include => "portfolio_type" )

		portfolio_table = portfolio_items.collect { |p| [ image_tag(formatted_portfolio_item_path(p.id, :png)), p.portfolio_type.column_space, diamond + " " + image_tag(formatted_portfolio_type_path(p.portfolio_type.id,:png))]}

		table(portfolio_table, {:columns => 3}, :class=> "portfolio_table")
	end
	
end

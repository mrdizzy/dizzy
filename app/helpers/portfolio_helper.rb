module PortfolioHelper
	
	def portfolio_table		
		
		portfolio_items = PortfolioItem.find_all_by_company_id(@company.id, :conditions => 
    	"portfolio_types.visible = '1'", :include => "portfolio_type" )

		portfolio_table = portfolio_items.collect { |p| ["<img src=\"/binaries/portfolio_image/#{p.id}.png\">", p.portfolio_type.column_space, "<img src=\"/binaries/portfolio_type/#{p.portfolio_type.id}\" alt=\"#{p.portfolio_type.description}\" />"]}

		table(portfolio_table, {:columns => 3}, :class=> "portfolio_table")
	end
	
end

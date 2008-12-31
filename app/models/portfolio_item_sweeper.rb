class PortfolioItemSweeper < ActionController::Caching::Sweeper

  observe PortfolioItem

  def after_destroy(record)
    expire_page hash_for_formatted_portfolio_item_path(:id => record.id, :format => :png)
    expire_page hash_for_portfolio_path(:id => record.company.id)
    expire_page hash_for_formatted_portfolio_path(:id => record.company.id, :format => :js)
    expire_page "/"
  end

end

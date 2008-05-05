class PortfolioItemSweeper < ActionController::Caching::Sweeper

  observe PortfolioItem

  def after_save(record)
    expire_page hash_for_formatted_portfolio_items_path(:id => record.id, :format => :png)
  end

  def after_destroy(record)
    expire_page hash_for_formatted_portfolio_items_path(:id => record.id, :format => :png)
  end

end

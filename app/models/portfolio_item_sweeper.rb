class PortfolioItemSweeper < ActionController::Caching::Sweeper

  observe PortfolioItem

  def after_save(record)
    expire_page hash_for_formatted_portfolio_path(record.id, :png)
  end

  def after_destroy(record)
    expire_page hash_for_formatted_portfolio_path(record.id, :png)
  end

end

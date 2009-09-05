class PortfolioItemSweeper < ActionController::Caching::Sweeper

  observe PortfolioItem

  def after_destroy(record)
    expire_page portfolio_item_path(record, :png)
    expire_page portfolio_path(record.company.id)
    expire_page portfolio_path(record.company, :js)
    expire_page "/"
  end

end

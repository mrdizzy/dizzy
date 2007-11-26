class PortfolioItemSweeper < ActionController::Caching::Sweeper

  observe PortfolioItem

  def after_save(record)
    expire_page(:controller => "binaries", :action=> "portfolio_image", :id => record.id, :extension => "png")
  end

  def after_destroy(record)
        expire_page(:controller => "binaries", :action=> "portfolio_image", :id => record.id, :extension => "png")
  end

end

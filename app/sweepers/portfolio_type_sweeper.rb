class PortfolioTypeSweeper < ActionController::Caching::Sweeper

  observe PortfolioType

  def after_save(record)
    expire_image(record)
  end

  def after_destroy(record)
    expire_image(record)
  end

  def expire_image(record)
  	expire_page hash_for_formatted_portfolio_type_path(:id => record.id, :format => :png)
  end

end

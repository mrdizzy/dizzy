class CompanySweeper < ActionController::Caching::Sweeper

  observe Company

  def after_save(record)
    expire_page hash_for_portfolio_path(:id => record.id)
    expire_page hash_for_formatted_portfolio_path(:id => record.id, :format => :js)
    expire_page hash_for_portfolios_path
    Company.pages(nil).total_pages.times { |n| expire_page "/portfolios/page/#{n+1}.js" }
  end
  
  def after_destroy(record)
    expire_page hash_for_portfolio_path(:id => record.id)
    expire_page hash_for_formatted_portfolio_path(:id => record.id, :format => :js)
    expire_page hash_for_portfolios_path
    Company.pages(nil).total_pages.times { |n| expire_page "/portfolios/page/#{n+1}.js" }
  end

end
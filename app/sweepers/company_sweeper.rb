class CompanySweeper < ActionController::Caching::Sweeper

  observe Company

  def after_save(record)
    expire_page portfolio_path(record)
    expire_page portfolio_path(record, :js)
    expire_page portfolios_path
    Company.pages(nil).total_pages.times { |n| expire_page "/portfolios/page/#{n+1}.js" }
  end
  
  def after_destroy(record)
    expire_page portfolio_path(record.id)
    expire_page portfolio_path(record.id, :js)
    expire_page portfolios_path
    Company.pages(nil).total_pages.times { |n| expire_page "/portfolios/page/#{n+1}.js" }
  end

end
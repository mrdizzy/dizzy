ActionController::Routing::Routes.draw do |map|
  map.resources :markdowns

  # Redirects
  REDIRECTS.each { |redirect| map.connect redirect.first, :controller => 'redirect', :url => redirect.last }

  map.resources :binaries, :member => { :grey => :get }
  map.resources :comments

  map.resources :comment_previews
  map.resources :companies
  map.resources :portfolio_items
  map.resources :portfolio_types
  map.resources :portfolios
	map.connect "/portfolio_types", :controller => "portfolio_types", :action => "update", :conditions => { :method => :put }
   
  # Named routes
  map.latest 'ruby_on_rails/latest', :controller => "contents", :action => "index"
  map.login 'login', :controller => "administrator_sessions", :action => "new"
  map.logout 'logout', :controller => "administrator_sessions", :action => "destroy" 
	map.paged_portfolios "/portfolios/page/:page.:format", :controller => "portfolios", :action => "index"
    
  # RESTful routes 
  map.resources :administrator_sessions
  map.resources :categories, :path_prefix => "/ruby_on_rails"    
  map.resources :cheatsheets, :path_prefix => "/ruby_on_rails", :collection => { :preview => :post }
	
	map.resources :contents, :path_prefix => "/ruby_on_rails" do |contents|
		contents.resources :comments do |comments|
			comments.resources :child_comments, :controller => "comments"
		end
	end

  map.root :controller => "welcome"   
  
end

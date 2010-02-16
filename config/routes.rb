ActionController::Routing::Routes.draw do |map|

  REDIRECTS.each { |redirect| map.connect redirect.first, :controller => 'redirect', :url => redirect.last }
  
  map.resources :administrator_sessions
  map.resources :binaries, :member => { :grey => :get }
  map.resources :categories   
  map.resources :comment_previews
  map.resources :comments
  map.resources :companies
  
  map.resources :contents, :as => "ruby_on_rails" do |contents|
    contents.resources :comments do |comments|
      comments.resources :child_comments, :controller => "comments"
    end
  end
  
  map.resources :markdowns
  map.resources :portfolio_items
  map.resources :portfolio_types
  map.resources :portfolios
  
	map.connect "/portfolio_types", :controller => "portfolio_types", :action => "update", :conditions => { :method => :put } 

  map.login 'login', :controller => "administrator_sessions", :action => "new"
  map.logout 'logout', :controller => "administrator_sessions", :action => "destroy" 
	map.paged_portfolios "/portfolios/page/:page.:format", :controller => "portfolios", :action => "index"

  map.root :controller => "welcome"   
  
end

ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
    
    # Redirects
    REDIRECTS.each do |redirect|    
    	map.connect redirect.first, :controller => 'redirect', :url => redirect.last
	end

    # Named routes
    map.latest 'ruby_on_rails/latest', :controller => "contents", :action => "index"
   map.login 'login', :controller => "administrator_sessions", :action => "new"
   map.logout 'logout', :controller => "administrator_sessions", :action => "destroy"    
	map.root :controller => "welcome"   
	map.formatted_welcome '/:page.:format', :controller => "welcome", :action => "index"
    
    # RESTful routes 
    map.resources :administrator_sessions
    map.resources :categories, :path_prefix => "/ruby_on_rails"
    
    map.resources :cheatsheets, :path_prefix => "/ruby_on_rails" do |contents|
		contents.resources :sections
	end
	
	map.resources :contents, :path_prefix => "/ruby_on_rails" do |contents|
		contents.resources :comments do |comments|
			comments.resources :child_comments, :controller => "comments"
		end
	end
	
	map.resources :binaries
	map.resources :comments
	map.resources :companies
	map.resources :portfolio_items
	map.resources :portfolio_types
	map.resources :portfolios
	map.paged_portfolios "/portfolios/page/:page", :controller => "portfolios", :action => "index"
	
  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  #map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
	map.connect ':controller/:action/:id'
end

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
     map.connect '/cheatsheets/rails-migrations.pdf', :controller => 'redirect', :url => '/ruby_on_rails/categories/migrations/contents/rails-migrations.pdf'      
     map.connect '/articles/rails-migrations.pdf', :controller => 'redirect', :url => '/ruby_on_rails/categories/migrations/contents/rails-migrations.pdf'       
    map.connect '/articles/rails-migrations', :controller => 'redirect', :url => '/ruby_on_rails/categories/migrations/contents/rails-migrations'
    map.connect '/articles/beginning-file-uploads', :controller => 'redirect', :url => '/ruby_on_rails/categories/file-handling/contents/beginning-file-uploads'

    # Named routes
    map.latest 'ruby_on_rails/latest', :controller => "contents", :action => "index"
    map.login 'login', :controller => "administrator_sessions", :action => "new"
	map.connect '/', :controller => "welcome"    
    
    # RESTful routes 
    map.resources :administrator_sessions
    map.resources :conversations
    
    map.resources :categories, :path_prefix => "/ruby_on_rails"
    map.resources :cheatsheets, :path_prefix => "/ruby_on_rails" do |contents|
		contents.resources :sections
	end
    map.resources :contents, :path_prefix => "/ruby_on_rails"
	
	map.resources :contents, :name_prefix => "main_" do |contents|
		contents.resources :comments do |comments|
			comments.resources :child_comments, :controller => "comments"
		end
	end
	
  # Portfolio Binary images
    map.connect "binaries/footer_logo/:id.:extension", :controller => "binaries", :action => "footer_logo"
	map.connect "binaries/footer_logo/:id/over.:extension", :controller => "binaries", :action => "grey_footer_logo"		
	map.connect "binaries/portfolio_image/:id.:extension", :controller => "binaries", :action => "portfolio_image"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  #map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
	map.connect ':controller/:action/:id'
end
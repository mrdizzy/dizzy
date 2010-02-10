class WelcomeController < ApplicationController
	
	caches_page :index
	
	def index
		@companies 	= Company.all(:order => 'RAND()', :limit => 6)
		@articles 	= Content.recent.all(:limit => 12)		
	end	
	
end

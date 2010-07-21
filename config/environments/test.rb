Dizzy::Application.configure do
	
	config.cache_classes = true
	
	# Log error messages when you accidentally call methods on nil.
	config.whiny_nils = true
	
	# Show full error reports and disable caching
	config.action_controller.consider_all_requests_local = true
	config.action_controller.perform_caching             = true
	
	config.action_mailer.delivery_method = :test

end
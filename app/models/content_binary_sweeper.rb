class BinarySweeper < ActionController::Caching::Sweeper
	
	observe Binary
	
	def after_save(binary)
expire_binary(binary.content.permalink)
	
	end
	
	def after_destroy(binary)
		expire_binary(binary.content.permalink)
	end
	
	private 
	
	def expire_binary(permalink)

	end
end
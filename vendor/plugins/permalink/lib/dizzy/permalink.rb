module Dizzy
	module Permalink
	
		def self.included(base)
			base.extend ClassMethods
		end
		
		module ClassMethods			
			def find_by_permalink(permalink)
				first(:conditions => ["permalink = ?", permalink]) or raise ActiveRecord::RecordNotFound, "Sorry, no record"
			end
		end
	end
	
end 
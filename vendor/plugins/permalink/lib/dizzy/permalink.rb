module Dizzy
	module Permalink
	
		def self.included(base)
			base.extend ClassMethods
		end
		
		module ClassMethods
			
			def permalink(permalink)
				if result=find_by_permalink(permalink)
					result
				else
					raise ActiveRecord::RecordNotFound, "Sorry, no record"
				end
			end
		end
	end
end
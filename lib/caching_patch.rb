module ActionController
	module Caching
    	module Pages
        	module ClassMethods
        		
        		 def cache_page(content, path)
    	     		 return unless perform_caching
		
        	 		benchmark "Cached page: #{page_cache_file(path)}" do
        		    	FileUtils.makedirs(File.dirname(page_cache_path(path)))
            			File.open(page_cache_path(path), "wb+") { |f| f.write(content) }
        			end
          		end
        	end
        
        	def cache_page(content = nil, options = nil)
        		return unless perform_caching && caching_allowed

		        path = case options
		          when Hash
		            url_for(options.merge(:only_path => true, :skip_relative_url_root => true, :format => params[:format]))
		          when String
		            options
		          else
		            request.path
		          end
		          self.class.cache_page(content || response.body, path)
        	end
         	
        end
	end
end
require 'maruku'

module MarukuWithCode
	def self.included(base)
		base.send :include, InstanceMethods
	end
	
	module InstanceMethods
	
		def parsed_content
		result = "Use numbered headers: true
HTML use syntax: true

{:rhtml: lang=rhtml html_use_syntax=true}
{:ruby: lang=ruby  html_use_syntax=true}
{:plaintext: lang=plaintext html_use_syntax=true}

# Table of Contents

* Table of Contents
{:toc}

" + self.content
			result = Maruku.new(result).to_html
		end
	end
end
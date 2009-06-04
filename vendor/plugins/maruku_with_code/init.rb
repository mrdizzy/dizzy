# Include hook code here

require 'maruku_with_code'
ActiveRecord::Base.send :include, MarukuWithCode 
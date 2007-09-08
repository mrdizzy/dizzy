class FormTestController < ApplicationController
	def test
		params.each_pair do |key, value|
			puts "#{key}--- #{value}"
		end
	end
end

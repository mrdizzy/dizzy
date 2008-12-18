class MarkdownsController < ApplicationController
	
	def create
		@content = params[:content]
		@content = Maruku.new(@content).to_html
		render :text => @content
	end
end

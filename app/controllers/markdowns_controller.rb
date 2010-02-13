class MarkdownsController < ApplicationController
	
	def show
		@content = Content.find(params[:id])
		@content = Maruku.new(@content.content).to_html
		@content= "<div id=\"article\">#{@content}</div>"
		render :text => @content
	end
	
	def create
		render :text => Maruku.new(params[:content]).to_html
	end
end

class ChangeStyle < ActiveRecord::Migration
	
	class Content < ActiveRecord::Base; end	
	class Article < Content; end
	
	def self.up
  	articles = Article.find(:all)
  	articles.each do |article|
  		article.style = "SNIPPET"
  		article.save!
  	end
  end
  
  def self.down
  end

end

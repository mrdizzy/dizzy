class ChangeStyle < ActiveRecord::Migration
  def self.up
  	articles = Article.find(:all)
  	article.each do |article|
  		article.style = "SNIPPET"
  		article.save!
  	end
  end

  def self.down
  end
end

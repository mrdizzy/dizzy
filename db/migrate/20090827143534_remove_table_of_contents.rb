class Content < ActiveRecord::Base
end

class Cheatsheet < Content
end

class Article < Content
end

class RemoveTableOfContents < ActiveRecord::Migration
  def self.up
   add_column :contents, :has_toc, :boolean
   contents = Content.all
   contents.each do |content|
      if content.content =~ /\:toc\}/
         content.content = content.content.gsub(/#(.*){:toc}/m, "")
         content.has_toc = true
         content.save!
      end
   end
   
  end

  def self.down
  remove_column :contents, :has_toc
  end
end

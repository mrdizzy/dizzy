class UpdateForeignKeys < ActiveRecord::Migration
  def self.up
  execute "ALTER TABLE pdfs DROP FOREIGN KEY fk_content_binaries"
  execute "DROP INDEX fk_content_binaries ON pdfs"
  execute "ALTER TABLE pdfs ADD FOREIGN KEY (content_id) REFERENCES contents(id)"
  
  execute "ALTER TABLE categories_contents DROP FOREIGN KEY fk_category_categories_contents"
  execute "ALTER TABLE categories_contents DROP FOREIGN KEY fk_content_categories_contents"
  execute "DROP INDEX fk_content_categories_contents ON categories_contents"
  execute "DROP INDEX fk_category_categories_contents ON categories_contents"
  execute "ALTER TABLE categories_contents ADD FOREIGN KEY (category_id) REFERENCES categories(id)"
  execute "ALTER TABLE categories_contents ADD FOREIGN KEY (content_id) REFERENCES contents(id)"
  
  execute "ALTER TABLE comments DROP FOREIGN KEY fk_comment_comments"
  execute "ALTER TABLE comments DROP FOREIGN KEY fk_content_comments"
  execute "DROP INDEX fk_comment_comments ON comments"
  execute "DROP INDEX fk_content_comments ON comments"
  execute "ALTER TABLE comments ADD FOREIGN KEY (content_id) REFERENCES contents(id)"
  execute "ALTER TABLE comments ADD FOREIGN KEY (parent_id) REFERENCES comments(id)"
  
  execute "ALTER TABLE contents ADD FOREIGN KEY (version_id) REFERENCES versions(id)"
  
  execute "ALTER TABLE contents_contents DROP FOREIGN KEY fk_secondary_content_contents"
  execute "ALTER TABLE contents_contents DROP FOREIGN KEY fk_main_content_contents"
  execute "DROP INDEX fk_secondary_content_contents ON contents_contents"
  execute "DROP INDEX fk_main_content_contents ON contents_contents"
  execute "ALTER TABLE contents_contents ADD FOREIGN KEY (content_id) references contents(id)"
  execute "ALTER TABLE contents_contents ADD FOREIGN KEY (related_id) references contents(id)"
  
  execute "ALTER TABLE portfolio_items DROP FOREIGN KEY fk_company_portfolio_items"
  execute "ALTER TABLE portfolio_items DROP FOREIGN KEY fk_portfolio_type_portfolio_items"
  execute "DROP INDEX portfolio_type_id ON portfolio_items"
  execute "DROP INDEX company_id ON portfolio_items"
  execute "ALTER TABLE portfolio_items ADD FOREIGN KEY (company_id) references companies(id)"
  execute "ALTER TABLE portfolio_items ADD FOREIGN KEY (portfolio_type_id) references portfolio_types(id)"
  end

  def self.down
  end
end

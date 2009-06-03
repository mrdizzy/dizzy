class InitializeForeignKeys < ActiveRecord::Migration
  def self.up
  
  	# binaries
	execute "alter table binaries add constraint fk_content_binaries foreign key (content_id) references contents(id)"
  
    # categories_contents
	execute "alter table categories_contents add constraint fk_content_categories_contents foreign key (content_id) references contents(id)"
	execute "alter table categories_contents add constraint fk_category_categories_contents foreign key (category_id) references categories(id)"
	
	# comments
	execute "alter table comments add constraint fk_content_comments foreign key (content_id) references contents(id)"
	
	# comments self-referential
	execute "alter table comments add constraint fk_comment_comments foreign key (parent_id) references comments(id)"
	
	# contents_contents
  	execute "alter table contents_contents add constraint fk_main_content_contents foreign key (content_id) references contents(id)"
  	execute "alter table contents_contents add constraint fk_secondary_content_contents foreign key (related_id) references contents(id)"	

	# portfolio_items
	execute "alter table portfolio_items add constraint fk_company_portfolio_items foreign key (company_id) references companies(id)"
	execute "alter table portfolio_items add constraint fk_portfolio_type_portfolio_items foreign key (portfolio_type_id) references portfolio_types(id)"

end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end

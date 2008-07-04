class AddMoreForeignKeys < ActiveRecord::Migration
  def self.up
	  	
	execute "alter table portfolio_items add constraint fk_company_portfolio_items foreign key (company_id) references companies(id)"
	execute "alter table portfolio_items add constraint fk_portfolio_type_portfolio_items foreign key (portfolio_type_id) references portfolio_types(id)"
	execute "alter table comments add constraint fk_comment_comments foreign key (parent_id) references comments(id)"

  end

  def self.down
  end
end

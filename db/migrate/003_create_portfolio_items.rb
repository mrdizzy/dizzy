class CreatePortfolioItems < ActiveRecord::Migration
  def self.up
    create_table :portfolio_items do |t|
      # t.column :name, :string
      t.column :portfolio_type_id, :integer
      t.column :company_id, :integer
    end
  execute "alter table portfolio_items
add constraint fk_portfolio_items_portfolio_types
foreign key (portfolio_type_id) references portfolio_types(id)"  
  execute "alter table portfolio_items
add constraint fk_portfolio_items_companies
foreign key (company_id) references companies(id)"  
  end

  def self.down
    drop_table :portfolio_items
  end
end

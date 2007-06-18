class CreatePortfolioItems < ActiveRecord::Migration
  def self.up
    create_table :portfolio_items do |t|
      # t.column :name, :string
      t.column :portfolio_type_id, :integer
      t.column :company_id, :integer
    end

  end

  def self.down
    drop_table :portfolio_items
  end
end

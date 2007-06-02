class CreatePortfolioTypes < ActiveRecord::Migration
  def self.up
    create_table :portfolio_types do |t|
      # t.column :name, :string
      t.column :description, :string, :limit => 40
      t.column :column_space, :integer
    end
  end

  def self.down
    drop_table :portfolio_types
  end
end

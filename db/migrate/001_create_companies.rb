class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      # t.column :name, :string
      t.column :name, :string, :limit => 40
      t.column :description, :string
    end
  end

  def self.down
    drop_table :companies
  end
end

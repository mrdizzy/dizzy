class CreateSections < ActiveRecord::Migration
  def self.up
    create_table :sections do |t|
      t.column :body, :text
      t.column :cheatsheet_id, :integer
      t.column :title, :string
      t.column :summary, :string
    end
  end

  def self.down
    drop_table :sections
  end
end

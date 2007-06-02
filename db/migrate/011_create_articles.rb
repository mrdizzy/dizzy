class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      # t.column :name, :string
      t.column :title, :string
      t.column :content, :text
      t.column :date, :datetime
      t.column :author_id, :integer
    end
  end

  def self.down
    drop_table :articles
  end
end

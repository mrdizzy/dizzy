class CreateArticles < ActiveRecord::Migration
  def self.up
  	create_table :authors do |t|
    	t.column :username, :string
    	t.column :firstname, :string
    	t.column :surname, :string
    	t.column :email, :string
    end
  	
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
      drop_table :authors
  end
end

class AlterAuthors < ActiveRecord::Migration
  def self.up
  	drop_table :authors
  	add_column :users, :firstname, :string
  	add_column :users, :surname, :string
  	add_column :users, :email, :string
  end

  def self.down
  	
  create_table "authors", :force => true do |t|
    t.column "username",  :string
    t.column "firstname", :string
    t.column "surname",   :string
    t.column "email",     :string
  end

  end
end

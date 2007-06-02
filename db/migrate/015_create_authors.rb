class CreateAuthors < ActiveRecord::Migration
  def self.up
    create_table :authors do |t|
    	t.column :username, :string
    	t.column :firstname, :string
    	t.column :surname, :string
    	t.column :email, :string
    end
  end

  def self.down
    drop_table :authors
  end
end

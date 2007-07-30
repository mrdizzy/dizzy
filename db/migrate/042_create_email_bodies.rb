class CreateEmailBodies < ActiveRecord::Migration
  def self.up
    create_table :email_bodies do |t|
    	t.column :body, :text
    end
  end

  def self.down
    drop_table :email_bodies
  end
end

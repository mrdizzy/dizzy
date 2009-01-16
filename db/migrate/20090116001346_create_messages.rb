class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|

      t.timestamps
      t.string :name
      t.string :message
      t.string :email
    end
  end

  def self.down
    drop_table :messages
  end
end

class CreateCheatsheets < ActiveRecord::Migration
  def self.up
    create_table :cheatsheets do |t|
    end
  end

  def self.down
    drop_table :cheatsheets
  end
end

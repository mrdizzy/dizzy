class CreateMarkdowns < ActiveRecord::Migration
  def self.up
    create_table :markdowns do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :markdowns
  end
end

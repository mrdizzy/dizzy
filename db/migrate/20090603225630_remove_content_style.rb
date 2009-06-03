class RemoveContentStyle < ActiveRecord::Migration
  def self.up
  remove_column :contents, :style
  end

  def self.down
  end
end

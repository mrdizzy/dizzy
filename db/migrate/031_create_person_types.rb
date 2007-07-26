class CreatePersonTypes < ActiveRecord::Migration
  def self.up
    create_table :person_types do |t|
    	t.column :description, :string
    end
  end

  def self.down
    drop_table :person_types
  end
end

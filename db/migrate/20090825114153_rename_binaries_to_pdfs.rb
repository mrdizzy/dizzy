class Binary < ActiveRecord::Base
end

class Thumbnail < Binary
end

class RenameBinariesToPdfs < ActiveRecord::Migration
  def self.up
  Thumbnail.destroy_all
  rename_table :binaries, :pdfs
  remove_column :pdfs, :type
  end

  def self.down
  end
end

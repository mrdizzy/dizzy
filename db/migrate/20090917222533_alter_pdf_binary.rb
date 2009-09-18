class AlterPdfBinary < ActiveRecord::Migration
  def self.up
  rename_column :pdfs, :pdf, :pdf_binary_data
  end

  def self.down
  rename_column :pdfs, :pdf_binary_data, :pdf
  end
end

class AlterPdfTable < ActiveRecord::Migration
  def self.up
    rename_column :pdfs, :binary_data, :pdf_binary_data
    rename_column :pdfs, :content_type, :pdf_content_type
    rename_column :pdfs, :filename, :pdf_filename
    remove_column :pdfs, :size
  end

  def self.down
  rename_column :pdfs, :pdf, :pdf_binary_data
  rename_column :pdfs, :pdf_content_type, :content_type
  rename_column :pdfs, :pdf_filename, :filename
  add_column :pdfs, :size, :integer
  end
end

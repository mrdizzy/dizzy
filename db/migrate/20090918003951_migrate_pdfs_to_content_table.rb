class MigratePdfsToContentTable < ActiveRecord::Migration
  def self.up
    add_column :contents, :pdf_binary_data, :binary, :limit => 2.megabytes
    add_column :contents, :pdf_filename, :string
    add_column :contents, :pdf_content_type, :string
    
    Cheatsheet.reset_column_information
    Cheatsheet.all.each do |c|
      pdf = c.pdf
      c.pdf_binary_data = pdf.pdf_binary_data
      c.pdf_filename = pdf.pdf_filename
      c.pdf_content_type = pdf.pdf_content_type
      c.save!
    end
    drop_table :pdfs
  end

  def self.down
  end
end

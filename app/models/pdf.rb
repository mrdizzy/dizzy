class Pdf < ActiveRecord::Base
	belongs_to :content
	belongs_to :cheatsheet, :foreign_key => "content_id"

	validates_presence_of :binary_data, :content_type, :size, :filename, :content_id	
	validates_existence_of :content, :on => :update
	validates_inclusion_of :size, :in => 1.kilobyte..700.kilobytes, :message => "must be between 1k and 700k"
	validates_format_of :content_type, :with => /(application\/pdf|binary\/octet-stream)/, :message => "must be a PDF file"
end

# == Schema Info
# Schema version: 20090827143534
#
# Table name: pdfs
#
#  id           :integer(4)      not null, primary key
#  content_id   :integer(4)      not null, default(0)
#  binary_data  :binary(16777215
#  content_type :string(255)
#  filename     :string(255)
#  size         :integer(4)
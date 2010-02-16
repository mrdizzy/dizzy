class Content < ActiveRecord::Base

	@@VERSIONS = { 1  => "1.2.0", 2 => "1.2.3", 3 => "2.0", 4 => "2.1", 5 => "3.0" }.freeze
	cattr_reader :VERSIONS
	
	has_and_belongs_to_many :categories
	has_and_belongs_to_many :related_articles, :class_name => "Content", :foreign_key => "related_id"
	has_many 				:comments, :dependent => :destroy, :order => "'created_at' DESC"
	
	validates_format_of		:permalink, :with => /^[a-z0-9-]+$/, :allow_blank => true
	validates_presence_of 	:content, :category_ids, :title, :description, :date, :user, :permalink, :version
	validates_uniqueness_of :permalink	

	named_scope :recent, lambda { { :conditions => ["date < ?", 1.hour.ago], :order => "date DESC"  } }
  
	has_binary :pdf, 
				   :content_type => /(application\/pdf|binary\/octet-stream)/,
				   :size => 1.kilobyte..700.kilobytes	
	
	def main_category()
		self.categories.first
	end
	
	def parsed_content		
		result = "Use numbered headers: true
HTML use syntax: true

{:rhtml: lang=rhtml html_use_syntax=true}
{:ruby: lang=ruby  html_use_syntax=true}
{:plaintext: lang=plaintext html_use_syntax=true}
"
if has_toc
	result << "
# Table of Contents

* Table of Contents
{:toc}
"
end

	result << self.content
		result = Maruku.new(result).to_html
	end
	
	def version
		Content.VERSIONS[super]
	end
	def to_param()	permalink	end
	def title()		layout == "Cheatsheet" ? super + " Cheatsheet" : super end
end

# == Schema Info
# Schema version: 20090919133116
#
# Table name: contents
#
#  id               :integer(4)      not null, primary key
#  version_id       :integer(4)
#  content          :text
#  date             :datetime
#  description      :string(255)
#  has_toc          :boolean(1)
#  pdf_binary_data  :binary(16777215
#  pdf_content_type :string(255)
#  pdf_filename     :string(255)
#  permalink        :string(255)
#  title            :string(255)
#  type             :string(255)
#  user             :string(255)
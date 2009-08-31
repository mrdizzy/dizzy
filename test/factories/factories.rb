## Sequences

Factory.sequence :permalink do |d|
	"a-valid-permalink-#{d}"
end

Factory.sequence :version_number do |v|
	v + 0.0
end

Factory.sequence :name do |d|
	"A Valid Name #{d}"
end

Factory.sequence :comment_name do |d|
	"Comment name #{d}"
end

Factory.sequence :portfolio_type_name do |d|
	"Portfolio Type #{d}"
end

Factory.sequence :category_name do |d|
	"Category #{d}"
end

Factory.sequence :comment_subject do |c|
   "Comment subject #{c}"
end

Factory.sequence :cheatsheet_name do |d|
	"Cheatsheet #{d}"
end

Factory.sequence :article_name do |d|
	"Article #{d}"
end

Factory.sequence :number do |n|
	n
end

### Factories

Factory.define :article do |c|
	c.permalink { Factory.next(:permalink) }
	c.title { Factory.next(:article_name) }
	c.categories {|categories| [categories.association(:category), categories.association(:category)]}  
	c.user "mr_dizzy"
	c.date 1.hour.ago
	c.association :version, :factory => :version
	c.description "Here is a description"
	c.content "Here is the content"
end

Factory.define :category do |c|
	c.permalink { Factory.next(:permalink) }
	c.name { Factory.next(:category_name) }
end

Factory.define :cheatsheet, :default_strategy => :build do |c|
	c.association :version, :factory => :version
	c.content "Here is the content of the cheatsheet"
	c.date        Time.now
	c.description "A brief description"
	c.permalink { Factory.next(:permalink) }
	c.title { Factory.next(:cheatsheet_name) }  
	c.user  "mr_dizzy"
	c.categories { |categories| [categories.association(:category), categories.association(:category)] }
end

Factory.define :comment do |c|
	c.name { Factory.next(:comment_name) }
	c.new true
	c.association :content, :factory => :article
	c.created_at 1.hour.ago
	c.body "Here is the body of the comment"
	c.subject { Factory.next(:comment_subject) }
	c.email "david.p@casamiento-cards.co.uk"
end

Factory.define :company do |c|
	c.name "Heavenly Chocolate Fountains"
	c.visible true
    c.portfolio_items { |items| [items.association(:portfolio_item_header)] }
	c.description "Fun, hilarity, zany, bold, offbeat"
end

Factory.define :pdf, :default_strategy => :build do |p|
	p.content_type "application/pdf"
	p.filename "cheatsheet.pdf"
	p.size 102324
	p.binary_data "0101010101"
end

Factory.define :portfolio_item do |p|
  p.association :portfolio_type
  p.data "data"
  p.size 10.kilobytes
end

Factory.define :portfolio_item_header, :class => PortfolioItem do |p|
  p.association :portfolio_type, :factory => :portfolio_type_header
  p.data "data"
  p.size 5.kilobytes
end

Factory.define :portfolio_type do |p|
  p.visible true
  p.column_space 1
  p.description { Factory.next(:portfolio_type_name) }
  p.uploaded_data { ActionController::TestUploadedFile.new(File.join(Rails.root,
'test', 'fixtures', 'letterhead.png'), 'image/png') }
  p.position { Factory.next(:number) }
end

Factory.define :portfolio_type_header, :class => PortfolioType do |p|
  p.visible true
  p.column_space 1
  p.description "Header"
  p.uploaded_data { ActionController::TestUploadedFile.new(File.join(Rails.root,
'test', 'fixtures', 'letterhead.png'), 'image/png') }
  p.position 0
end

Factory.define :version do |v|
	v.version_number { Factory.next(:version_number) }
end


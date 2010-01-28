require 'action_controller/test_case'
require 'test_help'

Factory.sequence(:permalink) { |d| "a-valid-permalink-#{d}" }
Factory.sequence(:version_number) { |v| v + 0.0 }
Factory.sequence(:name) { |d| "A Valid Name #{d}" }
Factory.sequence(:comment_name) { |d| "Comment name #{d}" }
Factory.sequence(:portfolio_type_name) { |d| "Portfolio Type #{d}" }
Factory.sequence(:category_name) { |d| "Category #{d}" }
Factory.sequence(:comment_subject) { |c| "Comment subject #{c}" }
Factory.sequence(:cheatsheet_name) { |d| "Cheatsheet #{d}" }
Factory.sequence(:article_name) { |d| "Article #{d}" }
Factory.sequence(:number) { |n| n }

Factory.sequence(:binary) do |b| 
	ActionController::TestUploadedFile.new(ActiveSupport::TestCase.fixture_path + "letterhead.png", "image/png", :binary) 
end

Factory.sequence(:pdf_file) do |b| 
	ActionController::TestUploadedFile.new(ActiveSupport::TestCase.fixture_path + "letterhead.png", "application/pdf", :binary) 
end

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

Factory.define(:version) { |v| v.version_number { Factory.next(:version_number) } }

Factory.define :cheatsheet, :default_strategy => :build do |c|
	c.version_id { Factory(:version).id }
	c.content "Here is the content of the cheatsheet"
	c.date Time.now
	c.description "A brief description"
	c.permalink { Factory.next(:permalink) }
	c.title { Factory.next(:cheatsheet_name) }  
	c.user "mr_dizzy"
	c.category_ids { [ Factory(:category).id, Factory(:category).id] }
	c.pdf { Factory.next(:pdf_file) }
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

Factory.define :portfolio_item do |p| 
	p.association :portfolio_type 
	p.image { Factory.next(:binary) }
end

Factory.define :portfolio_item_header, :class => PortfolioItem do |p|
  p.association :portfolio_type, :factory => :portfolio_type_header
  p.image { Factory.next(:binary) }
end

Factory.define :portfolio_type do |p|
  p.visible true
  p.column_space 1
  p.description { Factory.next(:portfolio_type_name) }
  p.position { Factory.next(:number) }
end

Factory.define :portfolio_type_header, :class => PortfolioType do |p|
  p.visible true
  p.column_space 1
  p.description "Header"
  p.position 0
end

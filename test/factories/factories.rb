Factory.sequence :permalink do |d|
	"a-valid-permalink-#{d}"
end

Factory.sequence :version_number do |v|
	v + 0.0
end

Factory.sequence :name do |d|
	"A Valid Name #{d}"
end

Factory.define :category do |c|
	c.permalink { Factory.next(:permalink) }
	c.name { Factory.next(:name) }
end

Factory.define :cheatsheet do |c|
#  version_id  :integer(4)
	c.content "Here is the content of the cheatsheet"
#  date        :datetime
	c.description "A brief description"
	c.permalink { Factory.next(:permalink) }
	c.title { Factory.next(:name) }  
	c.user  "mr_dizzy"
end

Factory.define :comment do |c|
	c.name "Malandra Burrows"
	c.new true
	c.association :content, :factory => :article
	c.created_at 1.hour.ago
	c.body "Here is the body of the comment"
	c.subject "Here is the subject of the comment"
	c.email "david.p@casamiento-cards.co.uk"
end

Factory.define :article do |c|
	c.permalink { Factory.next(:permalink) }
	c.title { Factory.next(:name) }
	c.categories {|categories| [categories.association(:category), categories.association(:category)]}  
	c.user "mr_dizzy"
	c.date 1.hour.ago
	c.association :version, :factory => :version
	c.description "Here is a description"
	c.content "Here is the content"
end

Factory.define :version do |v|
	v.version_number { Factory.next(:version_number) }
end


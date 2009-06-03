Factory.sequence :permalink do |d|
	"a-valid-permalink-#{d}"
end

Factory.sequence :name do |d|
	"A Valid Name #{d}"
end

Factory.define :category do |c|
	c.permalink { Factory.next(:permalink) }
	c.name { Factory.next(:name) }
end
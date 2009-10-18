$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'maruku'

markdown_string = <<-EOF
## Table methods

### change\_table

Provides a block that enables you to alter columns on an existing table using various shortcut methods.

	change_table :table_name do |t|
	  t.change :column_name, :new_column_type
	  t.remove :column_name
	end
{:ruby}

### create\_table

Creates a table on the database. Creates a table called `:table_name` and makes the table object available to a block that can then add columns to it by specifying column types or utilising shortcut methods such as using `belongs_to` to specify 
foreign keys...

	create_table :table_name, {table_options} do |t|
	  t.string :name, {column_options}
	end
{:ruby}

###### Table 1.2.1 `{table_options}`

Key             | Value                     | Description
----------------|---------------------------|-----------------------------------
`:force`        | `true` _or_ `false`	        |  if `true`, forces drop of an existing table of the same name before creation the new one
`:temporary`    | `true` _or_ `false`	        | if `true`, creates a temporary table, one that goes away when the application disconnects from the database 
`:id`	        | `true` _or_ `false`	        | if `false`, defines a table with no primary key, for example when you need to define a join table 
`:primary_key`  | `:symbol`	                | overrides the default name of `:id` for the primary column. Use this to specify the name of the column in the database that Rails will use to store the primary key
`:options`	| `"string"`	                | pass raw options to your underlying database, e.g. `auto_increment = 10000`. Note that passing options will cause you to lose the default `ENGINE=InnoDB statement`

### drop\_table

Destroys the specified table.

	drop_table :table_name
{:ruby}

### rename\_table

Renames the specified table.

	rename_table :old_table_name, :new_table_name
{:ruby}

## example\_migration.rb

	class CreateCustomers < ActiveRecord::Migration  

	  def self.up
		create_table :customers, :primary_key => :customer_id, :options => "auto_increment = 10000" do |t|
		  t.integer :customer_id
		  t.string :name,         :limit   => 30, :null => false
		  t.integer :age
		  t.boolean :premium,     :default => 0
		  t.binary :photo,        :limit   => 2.megabytes
		  t.timestamps
		  t.text :notes,          :default => "No notes recorded"
		end

		add_column :customers, :surname,  :string,   :limit => 50    

		add_column :orders,    :price,    :decimal,  :precision => 8, :scale => 2

		Customer.create :name => "David", :surname => "Smith", :age => "32", :premium => "1", :notes => "One of our top customers!"
	  end

	  def self.down 
		drop_table :customers
	  end
	end
{:ruby}

## Database Mapping

Rails          | db2	        | mysql         | openbase     | Oracle
---------------|----------------|---------------|--------------|--------
`:binary`      | blob(32678)    | blob	        | object       | blob
`:boolean`     | decimal(1)     | tinyint(1)    | boolean      | number(10)
`:date`        | date	        | date	        | date	       | date
`:datetime`    | timestamp      | datetime      | datetime     | date
`:decimal`     | decimal        | decimal       | decimal      | decimal
`:float`       | float          | float	        | float	       | number
`:integer`     | int	        | int(11)       | integer      | number(38)
`:string`      | varchar(255)   | varchar(255)  | char(4096)   | varchar2(255)
`:text`        | clob(32768)    | text          | text         | clob
`:time`        | time           | time          | time         | date
`:timestamp`   | timestamp      | datetime      | timestamp    | date

Rails          | postgresql     | sqlite        | sqlserver    | Sybase
---------------|----------------|---------------|--------------|---------------
`:binary`      | bytea          | blob          | image        | image
`:boolean`     | boolean        | boolean       | bit          | bit
`:date`        | date           | date          | datetime     | datetime
`:datetime`    | timestamp      | datetime      | datetime     | datetime
`:decimal`     | decimal        | decimal       | decimal      | decimal
`:float`       | float          | float         | float(8)     | float(8)
`:integer`     | integer        | integer       | int          | int
`:string`      | *              | varchar(255)  | varchar(255) | varchar(255)
`:text`        | text           | text          | text         | text
`:time`        | time           | datetime      | datetime     | time
`:timestamp`   | timestamp      | datetime      | datetime     | timestamp

## Rake tasks

`db:create`
`db:create:all`	
: Creates a single database specified in `config/databases.yml` for the current `RAILS_ENV` or creates all the databases

`db:drop`
`db:drop:all`
: Drops a single database specified in `config/databases.yml` for the current `RAILS_ENV` or drops all the databases

`db:fixtures:load`
: Load fixtures from `test/fixtures` into the current environment's database

`db:migrate`	
: Run all unapplied migrations

`db:migrate:up`
`db:migrate:down`	
: Move forward to the next migration, or back to the previous migration

`db:migrate VERSION=18`
: Migrate database to specific version

`db:migrate RAILS_ENV=production`	
: Use migrations to recreate tables in the testing or production databases

`db:schema:dump`	
: Create a `db/schema.rb` file that can be portably used against any database supported by ActiveRecord

`db:schema:load`
: Load a schema.rb file into the database

`db:sessions:create`
: Create a sessions table for use with `CGI::Sessions::ActiveRecordStore`

`db:sessions:clear`	
: Clear the sessions table

`db:structure:dump`
: Dump database structure to SQL file

`db:reset`
: Drops the database, creates the database and then runs migrations against the database. Takes a `VERSION` argument as well as `RAILS_ENV`

`db:rollback STEP=4`
: Takes a STEP argument to determine how many version to rollback, the default being one version

`db:test:prepare`	
: Clone your database structure into the test database

`db:version`
: Tells you the current version your database is at

## Directory structure

	RAILS_ROOT
		/db
			+ schema.rb
			/migrate
				+ 20081204220440_remove_sections_table.rb
				+ 20081204220455_add_customers_table.rb


## Shortcut methods

	t.column               t.change                t.rename
	t.remove               t.change_default        t.references    
	t.remove_references    t.belongs_to            t.remove_belongs_to
	t.timestamps           t.index                 t.remove_index

## Column methods

### add\_column

Creates a new column on the specified table.

	add_column :table_name, :column_name, :column_type, {column_options}
{:ruby}

###### Table 7.1.1 `{column_options}` {#add_column_options}

Key            | Value                   | Description
---------------|-------------------------|------------------------
`:null`	       | `true` _or_ `false`	 | if `false`, the underlying column has a `not null` constraint added by the database engine
`:limit`       | `integer`	         | set a limit on the size of the field
`:default`     | `string`              	 | set a default value for the column
`:precision`   | `integer`	         | Specifies the precision for a `:decimal` column.
`:scale`       | `integer`	         | Specifies the scale for a `:decimal` column.

### change\_column

Change the data type of the specified column

	change_column :table_name, :column_name, :new_column_type
{:ruby}

### rename\_column

Renames the specified column.

	rename_column :table_name, :old_column_name, :new_column_name 
{:ruby}

### remove\_column

Removes the specified column.

	remove_column :table_name, :column_name
{:ruby}

## Indexes

### add\_index

Creates an index for the specified column.

	add_index :table_name, :column_name, :unique => true
{:ruby}

### remove\_index

Remove an index from the specified column.

	remove_index :table_name, :column_name
{:ruby}

## Miscellaneous methods

### execute

Takes a single string identifying a valid SQL command to execute directly.

	execute "alter table line_items add constraint fk_line_item_products foreign key (product_id) references products(id)"
{:ruby}

### IrreversibleMigration

Use in the down method of a migration file to raise an exception when the `up` methods of the same migration file can not be reversed, e.g. changing a column type from `:integer` to `:string`.

	raise ActiveRecord::IrreversibleMigration
{:ruby}

## script/generate

	script/generate migration new_migration_filename 
	  field_name:column_type name:string age:integer date_of_birth:date
{:plaintext}

## Loading fixtures 

Fixtures contain data which can be loaded into your database using migrations. For example, to load data into a table named customers...

+ Create a directory, `db/migrate/data`
+ Create a file, `customers.yml`, inside `db/migrate/data`
+ Generate a new migration file: `ruby script/generate migration load_customers_data`
+ Edit it to load data from the `customers.yml` file into your customers table

### customers.yml

	melissa:
	  name: Melissa
	  age: 18
	david: 
	  name: David
	  age: 23	
{:ruby}

### migration.rb

	require 'active_record/fixtures'
	class LoadCustomerData
	 def self.up
	  down
	  directory = File.join(File.dirname(__FILE__), "data")
	  Fixtures.create_fixtures(directory, "customers")
	 end
	 def self.down
	  Customer.delete_all
	 end
	end
{:ruby}

EOF

doc = Maruku.new(markdown_string)
puts doc.to_html
class UpdatingArticleSyntax < ActiveRecord::Migration
  def self.up
  	
content = Content.find(15)
content.content = <<-EOF
Sometimes there are times when you want to use Rails' built-in RJS features, but without hitting the server. For simplicity sake, let's imagine that you want to visually highlight an area of the page when a user clicks on a link, but you don't want to make a call to the server for something as simple as this. Well you can do just that using the `link_to_function` helper in the view.

### link\_to\_function

`link_to_function` is normally used to provide a clickable link on your HTML that will call a specified JavaScript function. However it can also take a `page` block in exactly the same way that you use RJS templates. When the link is clicked, it will execute the JavaScript generated by the RJS block. Take this example...

    <div id="menu">
      Make me flash!
    </div>

    <div id="highlight_link">

    <%= link_to_function "Click me!" do |page|
      page['menu'].visual_effect :highlight
      page['highlight_link'].remove
    end %>

    </div>
{:rhtml}

This litle snippet of code will create a link that when clicked, will highlight the `menu div` and then remove the actual link from the page itself. _Remember:_ you'll need to include the Prototype library for this to work, by adding `<%= javascript_include_tag :defaults %>` in the `<head>` of your HTML page.

### Obtrusive?

Some people don't like this approach, as it creates "obtrusive" JavaScript. "Obtrusive" means that the JavaScript code is mixed in with the HTML rather than being abstracted out. It, also isn't very "Railsy" using it in the view. But most of Rails' JavaScript helpers create obtrusive JavaScript, so it depends upon how puritanical you want to be. For a quick way of manipulating the DOM, this is a simple and easy time-saving method to use.

EOF

content.save!

###########################################

content = Content.find(10)
content.content = <<-EOF

### What are helpers again?

Rails' helpers are most commonly used when you're creating HTML forms. Here are some helpers you've probably used:

* `form_for`
* `text_field`
* `collection_select`

They are methods available to the view that make creating HTML code a lot easier. When you're in the process of learning what they do, it's really useful to be able to instantly see the HTML they create, and a way of doing this is to use the Rails console. 

### The Rails console 

Go to the root directory of your application, then type the following...

    ruby script/console

After a few seconds you should see something like this...

    Loading development environment (Rails 2.0.2)
    >>

You can now start interacting with your Rails application via this command line interface. 

### Example

To use helper methods, you need to prefix them with `helper`. Let's test out the `text_field` helper...

    >> helper.text_field(:book, :title)
    => "<input id=\"book_title\" name=\"book[title]\" size=\"30\" type=\"text\" />"
    >>
{:ruby}

Or maybe we want to see how `radio_button` works...

    >> helper.radio_button(:wallpaper, :colour, "Green")
    => "<input id=\"wallpaper_colour_green\" name=\"wallpaper[colour]\" type=\"radio\" value=\"Green\" />"
    >>
{:ruby}

As you can see, this is a really good way to get a feel for Rails' helpers, as you can see the results of your code instantly.

EOF

content.save!

#############################################################################

content = Content.find(9)
content.content = <<-EOF

Imagine you have a table of articles for a blog. Now imagine that for each article, you would like to be able to list all similar articles. Or a table containing people, where you would like to link related people to each other. This is a `has_and_belongs_to_many` (HABTM) association, but there's only one table involved. It's a self-referential relationship: a person has many people, and one of those people may also have many other people, and so on. So how do we implement that in Rails?

### The join table

Like all other HABTM relationships, we'll need to create a join table that keeps track of which articles are related to one another. However, in this case, both of the ids in the join table will each belong to an article. We'll want a column to keep track of the main article's `id`, and a column that contains the `id` of the related article. Let's called this join table `related_articles` and create a migration...
    
    create_table "related_articles", :force => true, :id => false do |t|
  	    t.column "related_article_id", :integer
  	    t.column "main_article_id", :integer
    end
{:ruby}

Remember that as this is a join table, it doesn't require its own `id`, so we set `:id => false`. Now let's take a look at the `Article` class...
    
### The self-referential class

`Article` is just like any other class, except we need to be verbose when defining the HABTM relationship. In a standard HABTM relationship, Rails would be able to work out the name of the join table, but in this case, the join table doesn't join two models together, it joins a model back to itself. We need to specify some additional options as follows...

    class Article < ActiveRecord::Base
	
	    has_and_belongs_to_many :related_articles, :class_name => "Article", :join_table => "related_articles", :foreign_key => "main_article_id", :association_foreign_key => "related_article_id"
	
    end
{:ruby}
    
So what do each of those options do?

* `:join_table` is where we tell Rails the name of our join table. We called it `related_articles`. 
* `:foreign_key` specifies the name of the foreign key column that contains the id of the main article, the one that is acting as a parent of the related articles: we called this `main_article_id`
* `:association_foreign_key` is the name of the foreign key column that contains the id of our related articles--the articles that "belong to" our main article 
* `:class_name` contains the name of our current class, `Article`

### Implementation

A suitable interface to allow us to add related articles would be a select drop-down list that can accept multiple options. Let's edit the form in our `new.rhtml` view to allow us to select related articles when adding a new article...

    <% form_for(@article) do |f| %>

      <b>Content</b><br />
      <%= f.text_field :content %>
  
      <b>Title</b><br />
      <%= f.text_field :title %>
   
      <b>Related articles</b><br />
      <%= f.collection_select(:related_article_ids, Article.find(:all), :id, :title, {}, :multiple => true) %>
 
      <%= f.submit "Create" %>
    
    <% end %>
{:rhtml}

We use the `collection_select` helper with the `related_article_ids` method. This method automatically becomes available when we define a HABTM relationship, and it accepts an array of ids to insert into our join table. We use `Article.find(:all)` to provide a list of all the other articles in our database, and ask `collection_select` to format them so that the `:id` gets sent when we submit the form, but the `:title` is displayed in the drop-down list. We also enable `:multiple => true` so that we can choose more than one article. 

I won't go into any further details, as drop-down lists for HABTM are a completely separate article, but don't worry--it's one I'll be writing about soon (check the right-hand side to see our very own related articles, as I might already have written it!)

EOF
  	
content.save!

############################################################

content = Content.find(7)

content.content = <<-EOF

[Sexy Migrations] [1] is a plugin that provides a more concise syntax and a few new features for Rails migrations. Most of its functionality has now been added to the Rails 2.0 core. Let's take a look...

### Shorter column syntax

If we look at an old migration file, we can see that there's usually a lot of repetition when it comes to declaring columns in a table...

    class CreateCustomer < ActiveRecord::Migration

      def self.up 
        create_table :customers do |t|

          t.column :permission_id
          t.column :class_id

          t.column :firstname,    :string, :null => false
          t.column :surname,      :string, :null => false 
          t.column :email,        :string, :null => false
          t.column :age,          :integer
          t.column :created_at,   :datetime
          t.column :updated_at,   :datetime
        end
      end

      def self.down 
        drop_table :customers
      end
    end
{:ruby}

We declare three `:string` columns and make them all `:null => false`. We also declare three `:integer` columns. Spot the repetition? Wouldn't it be better if we could do this all on one line? Well now we can. The same migration file written for Rails 2.0 looks like this...

    class CreateCustomer < ActiveRecord::Migration

      def self.up 
        create_table :customers do |t|
          t.integer   :permission_id, :class_id, :age
          t.string    :firstname, :surname, :email, :null => false
          t.timestamps
        end
      end

      def self.down 
        drop_table :customers
      end
    end
{:ruby}

Instead of the old `t.column` syntax where you specify the column type such as a symbol, such as `:string` or `:integer`, after declaring the column name, we now specify the column type directly as a method on `t` instantly saving time. 

We can also specify all the column names that are to be assigned that column type, all on one line. Any options appended to the end of the line will be applied to all the specified columns, so the `:string` columns above will all have the `null => false` declaration. 

What about `t.timestamps`? This is a shortcut for specifying Rails' `created_at` and `updated_at` automagic columns.

### Foreign keys

In the above migration, we use two foreign keys, `:class_id` and `permission_id`. We could also use the new, more readable and intuitive syntax to declare these...

    t.references :class, :permission
{:ruby}

Or we can use...

    t.belongs_to :class, :permission
{:ruby}

...whichever naming convention you prefer, they both do the same thing. There is also a `:polymorphic` option for the `references` or `belongs_to` method. This is useful when you're using polymorphic associations, as it will not only create the foreign key, but also the `type` column as well. 

For example...

    t.belongs_to :permission, :polymorphic => true
{:ruby}

...will create the `permission_id` column and also a `permission_type` column. If you wish to declare a default polymorphic type, you can use...

    t.belongs_to :permission, :polymorphic => { :default => 'Administrator' }
{:ruby}

  [1]: http://errtheblog.com/post/2381 "Sexy Migrations plugin"

EOF

content.save!

##########################################################################

content = Content.find(6)

content.content = <<-EOF

Migrations are great when you're working on an application that's already in production, but when you're in the early stages of development and your database schema is constantly changing, it can get irritating and unwieldy to keep generating migration files. But now, there's a better way... 

Auto migrations is a [plugin] [1] that will make changing your database even quicker and easier than using normal migrations. It's intended to be used in the early stages of your application development, when your database schema is fluid and constantly being changed. And best of all, it's one of my favourite kind of plugins because you can remove it at any time and it won't affect your application. Let's take a look...

### Installation

First, let's install the auto_migrations plugin...

    ruby script/plugin install svn://errtheblog.com/svn/plugins/auto_migrations

This should export it into your `vendor/plugins` directory and provide you with two new rake tasks: `rake db:auto:migrate` and `rake db:schema:to_migration`.

### schema.rb file

Now let's take a look in the `db` directory of your Rails application, where you'll find a file named `schema.rb`. This is a little bit like a consolidated migrations file, and contains the migrations syntax for your complete database schema...

    create_table "users", :force => true do |t|
      t.column "name",            :string
      t.column "hashed_password", :string
      t.column "salt",            :string
      t.column "firstname",       :string
      t.column "surname",         :string
      t.column "email",           :string
    end

    create_table "companies", :force => true do |t|
      t.column "name",        :string, :limit => 40
      t.column "description", :string
    end
{:ruby}

What the auto_migrations plugin does, is allow you to edit your `schema.rb` file directly, and then run `rake db:auto:migrate` to have the changes applied automatically. That's right: there's no need to generate and edit migrations files, just edit `schema.rb` directly and the plugin will detect the changes you've made as soon as you run `rake db:auto:migrate`.

### Example

In the above example `schema.rb` file, we have a `companies` table...

    create_table "companies", :force => true do |t|
      t.column "name",        :string, :limit => 40
      t.column "description", :string
    end
{:ruby}

Let's imagine that we want to add a new column--a string labelled `email` with a `limit` of 60 characters--to the `companies` table. We just edit `schema.rb` and insert an extra `t.column` line:

    create_table "companies", :force => true do |t|
      t.column "name",        :string, :limit => 40
      t.column "description", :string
      t.column "email",       :string, :limit => 60
    end
{:ruby}

Now, when we run `rake db:auto:migrate`, the email column will be added. Just run rake:

    rake db:auto:migrate

And you'll see the new column added:

    -- add_column("companies", "email", :string)
    -> 0.0216s

Now is that magic, or is that magic? It works if you delete columns too. Just delete the line containing the column from the `schema.rb` file:

    create_table "users", :force => true do |t|
      t.column "name",            :string
      t.column "hashed_password", :string
      t.column "salt",            :string
      t.column "firstname",       :string
      t.column "surname",         :string
      t.column "email",           :string
    end
{:ruby}

Let's remove the `surname` column:

    create_table "users", :force => true do |t|
      t.column "name",            :string
      t.column "hashed_password", :string
      t.column "salt",            :string
      t.column "firstname",       :string
      t.column "email",           :string
    end
{:ruby}

Then run rake:

    rake db:auto:migrate

And hey presto:

    -- remove_column("users", "surname")
    -> 0.1250s

### Limitations

Because auto_migrations makes several assumptions, there a few things it cannot do, namely changing the name of columns: it would simply drop the existing column and then create a new one with a new name. However, it will notice all of the following changes to `schema.rb`:

* creating and dropping tables
* creating and removing columns
* changing the types of existing columns, for example from `:string` to `:integer`
* adding and removing indexes

### db:schema:to_migration

And finally, when you want to start working with traditional migrations, you can get auto_migrations to create an initial migrations file based on the current `schema.rb`. Just run...

    rake db:schema:to_migration

And it'll create a `001_initial_schema.rb` migration file in your `db/migrate` drectory. Fantastic!

  [1]: http://errtheblog.com/posts/65-automatically "auto_migrations plugin"

EOF

content.save!

#########################################

content = Content.find(2)
content.content = <<-EOF

In this tutorial, I'll create a simple application to upload photos through a simple HTML form, and store them in the database, then render and display them on demand. The steps we'll go through are as follows:

* _Create a model._ We'll use this model for the photographs, and we'll call it "Photo"
* _Create a migration._ Use a database migration to create a table in the database to hold the photographs
* _Handle the upload._ In the view, we'll create a template containing a HTML multi-part form and a corresponding action that will allow users to upload their photograph files
* _Render the image from the database._ Once you've got the images in the database, how do you pull them out and display them again? That's what I'll show you...

### Building the foundations

First things first: let's create the photograph model from the command line:

    ruby script/generate model photo

The next step is in the controller. Let's create a `photo_admin` controller to take care of uploading, editing and deleting photos:

    ruby script/generate controller photo_admin

We'll also use Rails' scaffolding generator to create some basic actions and views that we can edit and work with: 

    ruby script/generate scaffold photo photo_admin

You might be asked by the generator script if it's okay to overwrite some of the existing controller files. Seeing as we haven't edited them even once, you can safely answer yes. 

Using migrations, we'll create a simple table containing fields to hold a description of the image, along with a binary field that will hold the binary image data itself. Open the `001_create_photos.rb` migration in the `db/migrate` directory, and edit it as follows: 

    class CreatePhotos < ActiveRecord::Migration 
        def self.up create_table :photos do |t| 
            t.column :description, :string 
            t.column :content_type, :string 
            t.column :filename, :string 
            t.column :binary_data, :binary 
        end 
    end
{:ruby}

We can then run the migration from the command line:

    rake db:migrate

If all has gone well, you should now have a table named `photos` in your database with all the fields you need to hold your image data! The next step is in the controller. Let's create a `photo_admin controller` to take care of uploading, editing and deleting photos:

    ruby script/generate controller photo_admin

We'll also use Rails' scaffolding generator to create some basic actions and views that we can edit and work with:

    ruby script/generate scaffold photo photo_admin

You might be asked by the generator script if it's okay to overwrite some of the existing controller files. Seeing as we haven't edited them even once, you can safely answer yes. 

### Creating a new photo

Excellent! Now we have the foundations laid, it's time to handle uploading a new photograph to the database. As it happens, Rails' scaffolding generator has already created the new and create actions in the `photo_admin controller` we just generated, so we don't even need to touch it yet! Instead we'll concentrate on the view for the new action.

To start with, we need to create a multipart form in the `new.rhtml` view template. This allows the browser to send image files (or any other kind of files) to the server. Let's change the existing `form_tag` helper to a `form_for` helper that will wrap our `photo` model object:

    <% form_for(:photo, @photo, :url => {:action=>'create'}, :html=> {:multipart=>true}) do |form| %>
{:rhtml}

Notice the `:multipart => true` option at the end of the tag. It's always good to use the brackets and braces for clarity when using `form_for` with a multipart option. So many errors will happen if the form isn't rendered correctly using `:multipart => true`, so it's a time saver to always make sure you get that bit right from the beginning!

Next, let's remove the scaffolded entry for `<%= render :partial => 'form' %>` and instead add two form fields: one to handle the uploading of the photo, and the other to type in a description of the photo. 

    <%= form.file_field :image_file %> 
    <%= form.text_field :description %>
{:rhtml}

To create a field in the form which allows users to browse for and upload their files, we use Rails' specific `file_field` helper. It takes the same options as the `text_field`, the object assigned to the template (in this case, form) and the method for accessing a specific attribute (in this case `image_file`) Have you spotted the first anomaly yet? No? Well let's see: we've used `:description` in the `text_field` to enter our photo's description, and that's great, because we have a corresponding description field in our database table. But we've used `image_file` to upload our image data, and there's no corresponding `image_file` field in our `photos` table. So what's going on? 

It turns out that when uploading a file, you don't get receive just one string, such as the binary image data, but a more complex object containing not just the file's binary data but its filename and content-type (such as `image/jpg` or `image/gif`). These are all stored together in `:image_file`, so what we'll need to do is extract the data and assign it the correct model attributes. The best place to do that is in the `photo` model, in `app/models/photo.rb`

    class Photo < ActiveRecord::Base 
      def image_file=(input_data) 
        self.filename = input_data.original_filename 
        self.content_type = input_data.content_type.chomp 
        self.binary_data = input_data.read 
      end 
    end
{:ruby}

Here, we take the contents of `image_file` and we use three methods to extract the data and assign it to the model attributes that match our database table: the methods are `original_filename`, `content_type` and `read`. 

#### Methods

Method                    | Purpose                      
--------------------------|------------------------------------
`original_filename`       | gives you surprisingly enough the original filename of the file
`content_type`            | provides you with the content-type of the data, such as whether it is an `image/gif` or an `audio/wav` which is useful for validation 
`read`                    | lets you actually get at the binary data 

The `chomp` method at the end of `content_type` simply removes any extraneous newline characters, to make it neater. 

Now, if you go to `yourapp/photo_admin/new` you should be able to upload a file. Try a small one at first (under 10k would be good) You'll know if it works because you'll be returned to the `/photo_admin/list` action, and you'll see the details of your file, along with a lot of gibberish under the binary column. That's because Rails is rendering your binary image data as text. Instead, we want a way to get the binary image data back out of the database and display it as an actual image... 

### Rendering an image stored in the database

To do this, we'll create a new action in our `photo_admin` controller. We'll call it `code_image`: 

	def code_image 
	end
{:ruby}

In this action, we'll get the `id` (primary key) of the image file we want to display, we'll pull it out of the database and then we'll send it to the browser and tell it to render it correctly. Let's expand:

	def code_image 
    	@image_data = Photo.find(params[:id]) 
    	@image = @image_data.binary_data 
    	send_data (@image, :type => @image_data.content_type, :filename => @image_data.filename, :disposition => 'inline') 
	end
{:ruby}

Easy! In the above action we have: 

* taken the `id` of the `Photo` from the params supplied by the form, and retrieved it from the database into the `@image_data` object
* extracted the binary data out of the `binary_data` field
* used Rails' `send_data` method to render the binary image to the browser

The `send_data` method can take several options: 

#### Options

Key                 |               Value
--------------------|--------------------------------------------------
`:filename`         | Suggests a filename for the browser to use
`:type`             | Specifies an HTTP content type. Defaults to `application/octet-stream`. We've used the existing `content_type` information that was stored in the database when we saved the image
`:disposition`      | Specifies whether the file will be shown inline or downloaded. Valid values are `inline` and `attachment` (default). We want the image displayed in the browser, so we've used inline
`:status`           | Specifies the status code to send with the response. Defaults to `200 OK`. We don't really need to worry about this today

Test it out: go to `yourapp/photo_admin/code_image/1` (or whatever the `id` is of the image you want to display - make sure it is in the database!). If all is well, your image should be rendered in the browser. 

### Displaying the image inline

Let's change the `show.rhtml` view for the `photo_admin` controller, so that instead of displaying a lot of gibberish, we can display the image itself under the "binary" column. If we open the `show.rhtml` view we should see the following: 

	<% for column in Photo.content_columns %>
    	<%= column.human_name %>
    	<%=h @photo.send(column.name) %>
	<% end %>
{:rhtml}

This code simply gets all of the column names from the database and their content and displays them automatically. This is fine for the text-based fields, but not for the binary image field. So we'll use an if condition to display the `binary_data` column differently:

    <% for column in Photo.content_columns %> 
        <%= column.human_name %>
        <% if column.name == "binary_data" %>
            <%= image_tag("/photo_admin/code_image/\#{@photo.id}", :alt => "Image") %>
        <% else %>
            <%=h @photo.send(column.name) %>
        <% end %>
    <% end %>
{:rhtml}

Try it! Go to `yourapp/photo_admin/show/1` (or whatever the image `id` is you want to display) and your image should be displayed. In the above code, we're doing the following: 

* looping through each column, and checking to see if the name of the column (`column.name`) is set to `binary_data`
* if it is, then we use the `image_tag` command to render an image. The URL of the image is simply the action that we just created in the `photo_admin` controller to encode and render the image: `photo_admin/code_image/id` where id is the "id" of the image, in this case stored in the `@photo.id` instance variable
* if the column name isn't `binary_data`, we just display the standard content of the column as text

So now you have the `code_image` method in your `photo_admin` controller, whenever you want to encode and render an image inline, you just call `photo_admin/code_image/id` as the image URL. Simple! 

### Troubleshooting Tips

If you're getting `NoMethod` or other strange errors when uploading a file, try viewing the HTML of the new form after it has been rendered by your browser and before submitting it. Then you can make sure Rails is rendering the form correctly with the `multipart` entry. If you don't see `multipart` in the `<form>` tag, then that's your problem.

EOF

content.save!

  end

  def self.down
  end
end

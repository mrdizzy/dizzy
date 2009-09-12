require 'test_helper'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

ActiveRecord::Schema.define do 
  create_table :products do |t|
    t.belongs_to :category
    t.string :name
    t.binary :image
    t.integer :image_size
    t.string :image_content_type
    t.string :image_filename
  end
  create_table :categories do |t| 
    t.string :name
  end
end

ActionController::Routing::Routes.draw do |map|
  map.resources :categories do |categories|
    categories.resources :products
  end
end

module ClassMethods
  ActiveRecord::Base.attribute_method_suffix '_uploaded_data='
end

module InstanceMethods
  
  def attribute_uploaded_data=(attr,value)
    raise ArgumentError, "You can only upload files to a :binary column, '#{attr}' is of type #{column_for_attribute(attr).type}" unless column_for_attribute(attr).type == :binary 
    self.send("#{attr}_size=", value.size) 
    self.send("#{attr}_filename=", value.original_filename)
    self.send("#{attr}_content_type=", value.content_type)
    self.send("#{attr}=", value.read)
  end

end

ActiveRecord::Base.send(:extend, ClassMethods)
ActiveRecord::Base.send(:include, InstanceMethods)

class Product < ActiveRecord::Base
  belongs_to :category 
end

class Category < ActiveRecord::Base
  has_many :products
  accepts_nested_attributes_for :products
end

class CategoriesController < ActionController::Base

  def create
    @category = Category.new(params[:category])
    render :inline => @category.to_yaml
  end

end

class CategoriesControllerTest < ActionController::TestCase
  
  def test_1
    post :create, { :category => { :name => "Category name", :products_attributes => { 0 => { :name => "Pepsi Cola", :image_uploaded_data=> fixture_file_upload("letterhead.png", "image/png") } } } }
    category = assigns(:category)
    pp category.products
  end
  
end

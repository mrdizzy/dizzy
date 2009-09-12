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

module Dizzy
  module FileUploadToDb
    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
      
    end
     
    module ClassMethods      
      ActiveRecord::Base.attribute_method_suffix '_uploaded_data='
    end
  
    module InstanceMethods
      def attribute_uploaded_data=(attr,value)
        raise ArgumentError, "You can only upload files to a :binary column, '#{attr}' is of type #{column_for_attribute(attr).type}" unless column_for_attribute(attr).type == :binary 
        unless value.blank?
          self.send("#{attr}_size=", value.size) 
          self.send("#{attr}_filename=", value.original_filename)
          self.send("#{attr}_content_type=", value.content_type)
          self.send("#{attr}=", value.read)
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, Dizzy::FileUploadToDb)

class Product < ActiveRecord::Base
  validates_presence_of :image
  belongs_to :category 
end

class Category < ActiveRecord::Base
  has_many :products
  accepts_nested_attributes_for :products
end

class ActsAsBinaryTest < ActiveSupport::TestCase
  
  def setup
    @valid_product = Product.create!(:name => "Pepsi Cola", :image_uploaded_data => ActionController::TestUploadedFile.new("letterhead.png", "image/png"))
    @valid_category = Category.create!(:name => "Category")
  end
  
  def teardown
    Product.delete_all
    Category.delete_all
  end

  def test_1_should_succeed_on_update_with_valid_attributes
    @valid_product.update_attributes(:name => "Coca Cola", :image_uploaded_data => ActionController::TestUploadedFile.new("compliment.png", "image/png"))
    assert @valid_product.valid?
    assert_equal ActionController::TestUploadedFile.new("compliment.png", "image/png").read, @valid_product.image
    assert_equal "Coca Cola", @valid_product.name
  end
  
  def test_3_should_succeed_on_create_with_nested_model 
    @valid_category.products_attributes = [ { :name => "Fanta", :image_uploaded_data => ActionController::TestUploadedFile.new("letterhead.png", "image/png") } ]
   
    child_product = @valid_category.products.first
    
    assert_equal @valid_category.products.size, 1
    assert_equal "Fanta", child_product.name
  end
  
  def test_4_should_succeed_on_update_with_nested_model
    @valid_category.products << @valid_product
    @valid_category.save!
    
    @valid_category.products_attributes = [ { :name => "Lucozade", :id => @valid_product.id } ]
    assert_equal "Lucozade", @valid_category.products.first.name
    assert_equal ActionController::TestUploadedFile.new("letterhead.png", "image/png").read, @valid_category.products.first.image
  end
  
  def test_5_should_succeed_on_update_with_nested_model_and_empty_file_upload
    @valid_category.products << @valid_product
    @valid_category.save!
   
    @valid_category.products_attributes = [ { :name => "7UP", :image_uploaded_data => "", :id => @valid_product.id } ]
    @valid_category.save!
    
    assert_equal "7UP", @valid_category.products.first.name
    assert_equal ActionController::TestUploadedFile.new("letterhead.png", "image/png").read, @valid_category.products.first.image

  end
  
  def test_6_should_fail_on_create_with_empty_file_upload
    product = Product.new(:name => "Pepsi Cola", :image_uploaded_data => "")
    assert !product.valid?
    assert_equal 1, product.errors.size, product.errors.size
    assert_equal "can't be blank", product.errors[:image], product.errors.full_messages
  end

end
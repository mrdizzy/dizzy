require 'test_helper'
require '../lib/has_binary'
require '../lib/migrations_binary'
require '../lib/render_binary'
require '../init.rb'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

ActiveRecord::Schema.define do 
  create_table :products do |t|
    t.belongs_to :category
    t.string :name
    t.binary :image
    t.string :type
  end
  create_table :categories do |t| 
    t.string :name
  end
end

ActionController::Routing::Routes.draw do |map|
  map.resources :categories do |categories|
    categories.resources :products
  end
  map.resources :products
end


class Product < ActiveRecord::Base
  has_binary :image, 
                   :content_type => /(application\/pdf|binary\/octet-stream|image\/png)/,
                   :size => 1.kilobyte..700.kilobytes
  belongs_to :category 
end


class Category < ActiveRecord::Base
  has_many :products
  accepts_nested_attributes_for :products
end

class Jona < Product
end

class ActsAsBinaryTest < ActiveSupport::TestCase
  
  def setup
    @valid_product = Product.create!(:name => "Pepsi Cola", :image => ActionController::TestUploadedFile.new("letterhead.png", "image/png", :binary))
    @valid_category = Category.create!(:name => "Category")
  end
  
  def teardown
    Product.delete_all
    Category.delete_all
  end

  def test_1_should_succeed_on_update_with_valid_attributes
    @valid_product.update_attributes(:name => "Coca Cola", :image => ActionController::TestUploadedFile.new("compliment.png", "image/png", :binary))
    assert @valid_product.valid?

    assert_equal ActionController::TestUploadedFile.new("compliment.png", "image/png", :binary).read, @valid_product.image_binary_data
    assert_equal "Coca Cola", @valid_product.name
  end
  
  def test_3_should_succeed_on_create_with_nested_model 
    @valid_category.products_attributes = [ { :name => "Fanta", :image => ActionController::TestUploadedFile.new("letterhead.png", "image/png", :binary) } ]
   
    child_product = @valid_category.products.first
    
    assert_equal @valid_category.products.size, 1
    assert_equal "Fanta", child_product.name
  end
  
  def test_4_should_succeed_on_update_with_nested_model
    @valid_category.products << @valid_product
    @valid_category.save!
    
    @valid_category.products_attributes = [ { :name => "Lucozade", :id => @valid_product.id } ]
    assert_equal "Lucozade", @valid_category.products.first.name
    assert_equal ActionController::TestUploadedFile.new("letterhead.png", "image/png", :binary).read, @valid_category.products.first.image_binary_data
  end
  
  def test_5_should_succeed_on_update_with_nested_model_and_empty_file_upload
    @valid_category.products << @valid_product
    @valid_category.save!
   
    @valid_category.products_attributes = [ { :name => "7UP", :image => "", :id => @valid_product.id } ]
    @valid_category.save!
    
    assert_equal "7UP", @valid_category.products.first.name
    assert_equal ActionController::TestUploadedFile.new("letterhead.png", "image/png", :binary).read, @valid_category.products.first.image_binary_data

  end
  
  def test_6_should_fail_on_create_with_empty_file_upload
    product = Product.new(:name => "Pepsi Cola", :image => "")
    assert !product.valid?
    assert_equal 1, product.errors.size, "Should have 1 error message but has #{product.errors.size}: #{product.errors.full_messages}"
    assert_equal "can't be blank", product.errors[:image], product.errors.full_messages
  end

  def test_7_should_fail_on_create_with_invalid_content_type
    product = Product.new(:name => "Pepsi Cola", :image => ActionController::TestUploadedFile.new("letterhead.png", "image/gif", :binary))
    assert !product.valid?
    assert_equal 1, product.errors.size, "Should have 1 error message but has #{product.errors.size}: #{product.errors.full_messages}"
    assert_equal "is invalid", product.errors[:image_content_type], product.errors.full_messages
  end

  def test_8_should_fail_on_create_with_invalid_size
    product = Product.new(:name => "Pepsi Cola", :image => ActionController::TestUploadedFile.new("image_140_bytes.png", "image/png", :binary))
    assert !product.valid?
    assert_equal 1, product.errors.size, "Should have 1 error message but has #{product.errors.size}: #{product.errors.full_messages}"
    assert_equal =/should be between/, product.errors[:image], product.errors.full_messages
  end
end

class ProductsController < ActionController::Base
  def show
    @product = Product.find(params[:id])
    render :binary, @product => :image 
  end
end

class ProductsControllerTest < ActionController::TestCase

  def test_truth() assert true end
  
  def test_1_should_succeed_on_show
    @valid_product = Product.create!(:name => "Pepsi Cola", :image => ActionController::TestUploadedFile.new("letterhead.png", "image/png", :binary))

    get :show, :id => @valid_product.id
    assert_response :success
    assert_equal @valid_product.image_binary_data, @response.body, "Binary should be identical"
  end

end
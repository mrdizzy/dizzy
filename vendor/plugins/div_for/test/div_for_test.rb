require 'pp'
require 'test_helper'
require 'active_record'
require 'action_controller'
require 'action_view'
require 'div_for'

class Book < ActiveRecord::Base; end

class DivForTest < Test::Unit::TestCase
  
  def test_truth
    assert true
  end
  
  def test_dom_id
  
    conf = YAML::load(File.open(File.dirname(__FILE__) + '/database.yml'))

    ActiveRecord::Base.establish_connection(conf['sqlite3'])
    ActiveRecord::Schema.define do
      create_table "books" do |t|
        t.string :name
      end        
    end
    
    book        = Book.new
    controller  = ActionController::Base.new
    view        = ActionView::Base.new
    
    assert_equal "new_book_#{book.object_id}", controller.dom_id(book)
    
    result = view.div_for book do
      "<b>HTML!</b>" 
    end
    assert_equal "<div class=\"book\" id=\"new_book_#{book.object_id}\"><b>HTML!</b></div>", result
 
    book.save!

    assert_equal "book_#{book.id}", controller.dom_id(book) 
     
    result = view.div_for book do 
      "<b>HTML!</b>" 
    end       
    assert_equal "<div class=\"book\" id=\"book_#{book.id}\"><b>HTML!</b></div>", result
    
  end
  
end

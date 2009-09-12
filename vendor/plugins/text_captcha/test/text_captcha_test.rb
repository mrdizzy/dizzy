require 'test_helper'
require 'net/http'
require 'active_record'
require '../lib/dizzy/form_builder'
require '../lib/text_captcha'
require '../init'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

ActiveRecord::Schema.define do 
  create_table :authors do |t|
    t.string :name
  end
  create_table :books do |t|
    t.string :title
    t.belongs_to :author
  end
end

ActionController::Routing::Routes.draw do |map|
  map.resources :authors do |authors|
    authors.resources :books
  end
end

class Author < ActiveRecord::Base
  has_many :books
  accepts_nested_attributes_for :books
  acts_as_textcaptcha
end

class Book < ActiveRecord::Base
  belongs_to :author
  acts_as_textcaptcha
end

class AuthorsController < ActionController::Base
end

class CaptchaTest < ActionView::TestCase
  
  def test_truth 
    assert true
  end
  
  def test_1_forms
    author = Author.new(:name => "Douglas Coupland")
    author.books.build(:title => "Generation X")
    author.books.build(:title => "Girlfriend In A Coma")
    author.books.build(:title => "All Families Are Psychotic")
    
    assert_equal 3, author.books.size
    
    form_for author do |f|
      f.text_field :name
      f.captcha_question
      f.captcha_answer
      f.fields_for :books do |b|
        b.text_field :title
        b.captcha_question
        b.captcha_answer
        b.object_name
      end
     
    end
    
  end
  
  def protect_against_forgery?
    false
  end
  
end

class TestSubmission < ActiveSupport::TestCase

  def test_correct_submissions
   answer = " 99107\n\r"
   answer_confirmation = "caa1ca78b3cce39fd93722159cba55cb"
   book = Book.new(:title => "Generation X", :answer => answer, :answer_confirmation =>  [ answer_confirmation ] )
   assert book.valid?, "#{book.title} should be valid: #{book.errors.full_messages}"
  
    answer = " \n50414\n"
    answer_confirmation = "d1599afc9321bf94d0b209551ad6e87f" 
    book = Book.new(:title => "Girlfriend In A Coma", :answer => answer, :answer_confirmation => [  answer_confirmation ] )
    assert book.valid?, "#{book.title} should be valid: #{book.errors.full_messages}"
  
    possible_answers = ["  twenty eight\r", " 28\n\n "]
    answer_1 = "33e75ff09dd601bbe69f351039152189"
    answer_2 = "c3d206029972e8f24543aaab6a24f48c"
  
    possible_answers.each do |answer|
      book = Book.new(:title => "All Families Are Psychotic", :answer => answer, :answer_confirmation => [ answer_1, answer_2 ] )    
       assert book.valid?, "#{book.title} should be valid: #{book.errors.full_messages}"
    end
  end
  
  def test_invalid_submissions
   answer = "99102"
   answer_confirmation = "caa1ca78b3cce39fd93722159cba55cb"
   book = Book.new(:title => "Generation X", :answer => answer, :answer_confirmation => [ answer_confirmation ] )
   assert !book.valid?, "#{book.title} should be invalid"
   assert book.errors.count, 1
   assert_equal "is not the correct answer.", book.errors[:answer]
  end

end
require 'test_helper'
require 'active_record'
require 'action_controller'
require 'action_view'
require 'action_view/test_case'
require 'text_captcha'
require 'captcha_view'
require 'init'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

ActiveRecord::Schema.define do 
  create_table :books do |t|
    t.string :title
  end
end

ActionController::Routing::Routes.draw do |map|
  map.resource :books
end

class Book < ActiveRecord::Base
  acts_as_textcaptcha
end

class CaptchaTest < ActionView::TestCase
  
  def test_truth 
    assert true
  end
  
  def test_1_forms
  
    form_for Book.new do |f|
      puts f.captcha
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
   book = Book.new(:title => "Generation X", :answer => answer, :answer_confirmation =>  { 0 => { :answer_confirmation => answer_confirmation } } )
   assert book.valid?, "#{book.title} should be valid: #{book.errors.full_messages}"
  
    answer = " \n50414\n"
    answer_confirmation = "d1599afc9321bf94d0b209551ad6e87f" 
    book = Book.new(:title => "Girlfriend In A Coma", :answer => answer, :answer_confirmation => { 0 => { :answer_confirmation => answer_confirmation } } )
    assert book.valid?, "#{book.title} should be valid: #{book.errors.full_messages}"
  
    possible_answers = ["  twenty eight\r", " 28\n\n "]
    answer_1 = "33e75ff09dd601bbe69f351039152189"
    answer_2 = "c3d206029972e8f24543aaab6a24f48c"
  
    possible_answers.each do |answer|
      book = Book.new(:title => "All Families Are Psychotic", :answer => answer, :answer_confirmation => { 0 => { :answer_confirmation => answer_1 }, 1 => { :answer_confirmation => answer_2 } } )    
       assert book.valid?, "#{book.title} should be valid: #{book.errors.full_messages}"
    end
  end
  
  def test_invalid_submissions
   answer = "99102"
   answer_confirmation = "caa1ca78b3cce39fd93722159cba55cb"
   book = Book.new(:title => "Generation X", :answer => answer, :answer_confirmation =>  { 0 => { :answer_confirmation => answer_confirmation } } )
   assert !book.valid?, "#{book.title} should be invalid"
   assert book.errors.count, 1
   assert_equal "is not the correct answer.", book.errors[:answer]
  end

end
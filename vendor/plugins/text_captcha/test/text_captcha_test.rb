require 'test_helper'
require 'active_record'
require 'action_controller'
require 'action_view'
require 'action_view/test_case'
require 'text_captcha'
require 'captcha_view'
require 'init'

#require 'action_view/test_case'

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
      #puts f.captcha
    end
    
  end
  
  def protect_against_forgery?
    false
  end
  
end

class TestSubmission < ActiveSupport::TestCase
  answer = "James \n"
  answer_confirmation = "b4cc344d25a2efe540adbf2678e2304c"
  book = Book.new(:title => "Generation X", :answer => answer, :answer_confirmation =>  { 0 => { :answer_confirmation => answer_confirmation } } )

  answer= "50414"
  answer_confirmation = "d1599afc9321bf94d0b209551ad6e87f" 
  book = Book.new(:title => "Generation X", :answer => answer, :answer_confirmation => { 0 => { :answer_confirmation => answer_confirmation } } )
    book.save
    #puts book.encrypted_answer
    puts 
   #puts book.answer_confirmation.values.detect { |v| v == book.encrypted_answer }
   puts book.valid?
   
  possible_answers = ["twenty eight\r", "28\n"]
  answer_1 = "33e75ff09dd601bbe69f351039152189"
  answer_2 = "c3d206029972e8f24543aaab6a24f48c"
 
  possible_answers.each do |answer|
    book = Book.new(:title => "Generation X", :answer => "twenty eight", :answer_confirmation => { 0 => { :answer_confirmation => answer_1 }, 1 => { :answer_confirmation => answer_2 } } )    

  end

end
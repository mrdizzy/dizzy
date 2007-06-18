require File.dirname(__FILE__) + '/../test_helper'

class CheatsheetTest < Test::Unit::TestCase
  fixtures :cheatsheets

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_invalid_with_empty_attributes
  	cheatsheet = Cheatsheet.new
  	fields = %w{ title description pdf thumbnail author_id date filename content_type size thumbnail_size thumbnail_content_type content permalink }  	
  	assert !cheatsheet.valid?
  	fields.each do |field|  		
  		assert cheatsheet.errors.invalid?(field.to_sym), "error on #{field}"
  	end
  end
  
  
end

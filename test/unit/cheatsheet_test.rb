require File.dirname(__FILE__) + '/../test_helper'

class CheatsheetTest < Test::Unit::TestCase
  fixtures :contents

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_invalid_with_empty_attributes
  	cheatsheet = Cheatsheet.new
  	fields = %w{ title description user_id date permalink version_id }  	
  	assert !cheatsheet.valid?
  	fields.each do |field|  		
  		assert cheatsheet.errors.invalid?(field.to_sym), "error on #{field}"
  	end
  end
  
end

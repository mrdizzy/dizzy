require File.dirname(__FILE__) + '/../test_helper'

class BinaryTest < Test::Unit::TestCase
  fixtures :binaries

  # Replace this with your real tests.
  def test_truth
    assert true
  end
 
  def test_thumbnail_size
  	png = binaries(:rails_migrations_png)
  	png.size = ""
  	assert !png.valid?
  	
  	png.size = 26.kilobytes
  	assert png.valid?
  	
  	png.size = 67.kilobytes
  	assert !png.valid?
  end
  
  def test_thumbnail_content_type
  	flunk
  end

  def test_binary_content_id 
  	flunk
  end

  def test_binary_filename
  	flunk
  end
  
end
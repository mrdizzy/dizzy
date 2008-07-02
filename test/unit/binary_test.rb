require File.dirname(__FILE__) + '/../test_helper'

class BinaryTest < Test::Unit::TestCase
  fixtures :binaries

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_cheatsheet_content_type
  	pdf = binaries(:rails_migrations_pdf)
  	assert pdf.save
  	
  	pdf.content_type = "image/png"
  	assert !pdf.save
  	assert_equal "Must be a PDF file", pdf.errors.on(:content_type)
  	
  	pdf.content_type = "application/gpdf"
  	assert !pdf.save
  	assert_equal "Must be a PDF file", pdf.errors.on(:content_type)
  	
  	pdf.content_type = "application/pdf"
  	assert pdf.save   
  end
  
  def test_cheatsheet_size 
  	pdf = binaries(:rails_migrations_pdf)
  	pdf.size = ""
  	assert !pdf.save
  	
  	pdf.size = 1000000
  	assert pdf.save
  	
  	pdf.size = 3000000
  	assert !pdf.save
  end
  
  def test_thumbnail_size
  	flunk
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
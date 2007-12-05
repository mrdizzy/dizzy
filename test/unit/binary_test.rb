require File.dirname(__FILE__) + '/../test_helper'

class BinaryTest < Test::Unit::TestCase
  fixtures :binaries

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_pdf_content_type
  	pdf = binaries(:migrations_pdf)
  	assert pdf.save
  	
  	pdf.content_type = "image/png"
  	assert !pdf.save
  	assert_equal "Must be a PDF file", pdf.errors.on(:content_type)
  	
  	pdf.content_type = "application/-xpdf"
  	assert !pdf.save
  	assert_equal "Must be a PDF file", pdf.errors.on(:content_type)
  	
  	pdf.content_type = "application/pdf"
  	assert pdf.save 
  	
  	pdf.size = ""
  	assert !pdf.save
  	
  	pdf.size = 800000
  	assert pdf.save
  	
  	pdf.size = 3000000
  	assert !pdf.save
  	
  end
end

require File.dirname(__FILE__) + '/../test_helper'

class PdfTest < Test::Unit::TestCase
  fixtures :binaries
  fixtures :contents
  
  def test_cheatsheet_content_type_should_be_valid
  	pdf = binaries(:rails_migrations_pdf)
  	assert pdf.valid?, pdf.errors.full_messages
  	 	
  	pdf.content_type = "image/png"
  	assert !pdf.save
  	assert_equal "must be a PDF file", pdf.errors.on(:content_type)
  	
  	pdf.content_type = "application/gpdf"
  	assert !pdf.save
  	assert_equal "must be a PDF file", pdf.errors.on(:content_type)
  	
  	pdf.content_type = "application/pdf"
  	assert pdf.save   
  end
  
  def test_cheatsheet_size_should_be_less_than_700k
  	pdf = binaries(:rails_migrations_pdf)
  	pdf.size = ""
  	assert !pdf.valid?
  	
  	pdf.size = 250.kilobytes
  	assert pdf.valid?
  	
  	pdf.size = 701.kilobytes
  	assert !pdf.valid?
  	assert_equal "must be between 1k and 700k", pdf.errors.on(:size)
  end
  
end
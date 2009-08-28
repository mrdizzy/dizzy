require File.dirname(__FILE__) + '/../test_helper'

class PdfTest < ActiveSupport::TestCase
  
  def test_1_pdf_content_type_should_fail_when_invalid
	pdf = Factory.create(:cheatsheet, :pdf => Factory.build(:pdf)).pdf
	
	assert pdf.valid?, pdf.errors.full_messages
	
	["image/png", "application/gpdf"].each do |type|
		pdf.content_type = type
		pdf.valid?
		assert_equal "must be a PDF file", pdf.errors.on(:content_type)	
		assert_equal 1, pdf.errors.size
	end
 
  end
  
  def test_2_pdf_size_should_fail_when_invalid
	pdf = Factory.create(:cheatsheet, :pdf => Factory.build(:pdf)).pdf
	
	[701.kilobytes, 999.bytes, 1.megabyte].each do |size|
		pdf.size = size
		assert !pdf.valid?, pdf.errors.full_messages
		assert_equal 1, pdf.errors.size
	end
  end
  
  def test_3_pdf_size_should_suceed_when_valid
	pdf = Factory.create(:cheatsheet, :pdf => Factory.build(:pdf)).pdf
	[700.kilobytes, 500.kilobytes, 100.kilobytes, 2.kilobytes].each do |size|
		pdf.size = size
		assert pdf.valid?, pdf.errors.full_messages
	end
  end
  
  def test_4_pdf_size_should_fail_when_blank
	pdf = Factory.create(:cheatsheet, :pdf => Factory.build(:pdf)).pdf
	pdf.size = ""
	pdf.valid?
	assert_equal 2, pdf.errors.size
	assert_equal ["can't be blank", "must be between 1k and 700k"], pdf.errors[:size]
  end
  
  def test_5_pdf_should_fail_with_empty_content_id
	pdf = Factory.build(:pdf, :content_id => nil)
	assert !pdf.valid?, "Should be invalid"
	assert_equal "can't be blank", pdf.errors[:content_id]
	assert_equal 1, pdf.errors.size
  end
  
  def test_6_pdf_should_fail_with_invalid_content_id
   pdf = Factory.build(:pdf, :content_id => 13232323232111)
   assert !pdf.valid?, "Should be invalid"
   assert_equal "doesn't exist", pdf.errors[:content]
   assert_equal 1, pdf.errors.size
  end
  
end

# == Schema Info
# Schema version: 20090827143534
#
# Table name: pdfs
#
#  id           :integer(4)      not null, primary key
#  content_id   :integer(4)      not null, default(0)
#  binary_data  :binary(16777215
#  content_type :string(255)
#  filename     :string(255)
#  size         :integer(4)
require File.dirname(__FILE__) + '/../test_helper'

class CheatsheetTest < ActiveSupport::TestCase

   def test_truth
      assert true
   end
   
   def valid_pdf_file
   		@valid_pdf_file ||= ActionController::TestUploadedFile.new("../fixtures/letterhead.png", "application/pdf", :binary)
   end
  
   def test_1_should_fail_with_empty_pdf
      cheatsheet = Factory.build(:cheatsheet, :pdf => nil)
	  cheatsheet.valid?
	  
	  assert_equal 1, cheatsheet.errors.size
      assert_equal "can't be blank", cheatsheet.errors[:pdf]
   end
   
	def test_2_should_suceed_with_valid_pdf
		cheatsheet = Factory.build(:cheatsheet, :pdf => valid_pdf_file)
		assert cheatsheet.errors.empty?
		assert cheatsheet.errors.empty?
	end
  
  def test_3_pdf_content_type_should_fail_when_invalid
	["image/png", "application/gpdf"].each do |type|
		cheatsheet = Factory.build(:cheatsheet, :pdf => valid_pdf_file)
		cheatsheet.valid?
		assert_equal "is invalid", cheatsheet.errors[:pdf_content_type]
		assert_equal 1, cheatsheet.errors.size, "Should have 1 error but has the following errors: #{cheatsheet.errors.full_messages}"
	end

  end

  def test_4_pdf_size_should_fail_when_invalid
	
	[701.kilobytes, 999.bytes, 1.megabyte].each do |size|
		
	end
  end

  def test_5_pdf_size_should_suceed_when_valid
	cheatsheet = Factory.create(:cheatsheet, :pdf => valid_pdf_file)
	[700.kilobytes, 500.kilobytes, 100.kilobytes, 2.kilobytes].each do |size|
		cheatsheet.pdf_size = size
		assert cheatsheet.valid?, cheatsheet.errors.full_messages
	end
  end
  
end

# == Schema Info
# Schema version: 20090918003951
#
# Table name: contents
#
#  id               :integer(4)      not null, primary key
#  version_id       :integer(4)
#  content          :text
#  date             :datetime
#  description      :string(255)
#  has_toc          :boolean(1)
#  pdf_binary_data  :binary(16777215
#  pdf_content_type :string(255)
#  pdf_filename     :string(255)
#  permalink        :string(255)
#  title            :string(255)
#  type             :string(255)
#  user             :string(255)
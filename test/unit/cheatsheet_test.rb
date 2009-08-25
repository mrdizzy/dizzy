require File.dirname(__FILE__) + '/../test_helper'

class CheatsheetTest < ActiveSupport::TestCase

   def test_truth
      assert true
   end
  
   def test_1_should_fail_with_empty_pdf
      cheatsheet = Factory.build(:cheatsheet, :pdf => nil)
	  cheatsheet.valid?
	  
	  assert_equal 1, cheatsheet.errors.size
      assert_equal ["Pdf can't be blank"], cheatsheet.errors.full_messages
   end
   
	def test_2_should_suceed_with_valid_pdf
		cheatsheet = Factory.create(:cheatsheet, :pdf => Factory.build(:pdf))
		assert cheatsheet.errors.empty?
		assert cheatsheet.pdf.errors.empty?
	end
  
  
   def test_3_should_delete_associated_pdf_on_destroy
	3.times do |c|
	 Factory.create(:cheatsheet, :pdf => Factory.build(:pdf))
	end

 	assert_difference(['Cheatsheet.count', 'Pdf.count'], -2) do
 		Cheatsheet.first.destroy
		Cheatsheet.last.destroy
 	end
  end
  
end

require File.dirname(__FILE__) + '/../test_helper'

class CheatsheetTest < ActiveSupport::TestCase

   def test_truth
      assert true
   end
  
  #TODO: Rewrite tests
  
   def test_1_should_fail_without_pdf
      cheatsheet = Factory.build(:cheatsheet, :pdf => nil)
      assert !cheatsheet.valid?
      assert_equal ["Pdf can't be blank"], cheatsheet.errors.full_messages
   end
  
   def test_2_should_destroy_dependencies
   3.times do |number|
      Factory.create(:cheatsheet)
   end
   puts Cheatsheet.count
   Cheatsheet.all.each do |c|
   puts c.pdf
   end
  	assert_difference(['Cheatsheet.count', 'Pdf.count'], -1) do
  		Cheatsheet.first.destroy
  	end
  end
  
end

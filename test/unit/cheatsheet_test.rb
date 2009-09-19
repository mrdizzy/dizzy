require File.dirname(__FILE__) + '/../test_helper'

class CheatsheetTest < ActiveSupport::TestCase

  def test_truth; assert true; end
  
  def test_1_should_fail_with_empty_pdf
    cheatsheet = Factory.build(:cheatsheet, :pdf => nil)
    assert !cheatsheet.valid?, "Cheatsheet should be invalid"
  
    assert_equal 1, cheatsheet.errors.size, "Should have 1 error but has the following errors: #{cheatsheet.errors.full_messages}"
    assert_equal "can't be blank", cheatsheet.errors[:pdf]
  end
  
  def test_2_should_suceed_with_valid_pdf
    cheatsheet = Factory.build(:cheatsheet)
    assert cheatsheet.valid?, "Cheatsheet should be valid"
    assert cheatsheet.errors.empty?, "Cheatsheet should have no errors"
  end
  
  def test_3_pdf_content_type_should_fail_when_invalid
    ["image/png", "application/gpdf", "application/exe"].each do |type|
      cheatsheet = Factory.build(:cheatsheet)

      assert !cheatsheet.valid?, "Cheatsheet should not be valid"
      assert_equal "is invalid", cheatsheet.errors[:pdf_content_type], "Cheatsheet should have error on content_type"
      assert_equal 1, cheatsheet.errors.size, "Should have 1 error but has the following errors: #{cheatsheet.errors.full_messages}"
    end
  end
  
  def test_4_pdf_size_should_fail_when_invalid
    [701.kilobytes, 999.bytes, 1.megabyte].each do |size|
      flunk
    end
  end
  
  def test_5_pdf_size_should_suceed_when_valid
    cheatsheet = Factory.create(:cheatsheet)
    [700.kilobytes, 500.kilobytes, 100.kilobytes, 2.kilobytes].each do |size|
      flunk
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
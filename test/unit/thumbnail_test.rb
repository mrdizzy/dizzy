require File.dirname(__FILE__) + '/../test_helper'

class BinaryTest < ActiveSupport::TestCase
  fixtures :binaries, :contents

  def test_truth
    assert true
  end
 
  def test_thumbnail_size
  	png = binaries(:action_mailer_png)
  	png.size = ""
  	assert !png.valid?
  	
  	png.size = 26.kilobytes
  	assert png.valid?
  	
  	png.size = 67.kilobytes
  	assert !png.valid?
  end
  
end
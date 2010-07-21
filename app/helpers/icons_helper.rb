module IconsHelper
	def location_icon() 	image_tag("f/small_icons/you-are-here.gif", :alt => "You are here:", :size=> "25x24").html_safe; end	
	def asterisk() 			image_tag("f/bullets/pixels/asterisk.png", :alt => "*").html_safe; end
	def square()			image_tag("f/bullets/pixels/square.png", :alt => "&mdash;").html_safe; end
	def bigarrow() 			image_tag("f/bullets/pixels/bigarrow.png", :size=> "17x13", :alt => "->").html_safe; end	
	def bigleftarrow() 		image_tag("f/bullets/arrows/bigleftarrow.png", :size => "17x13", :alt => "->").html_safe; end		
	def diamond() 			image_tag("f/bullets/pixels/diamond.png", :size=> "5x5", :alt => "*").html_safe; end
	def solid_arrow() 		image_tag("f/bullets/arrows/solidarrow.png", :size => "13x9", :alt => ">").html_safe; end
	def spiro() 			"<div class=\"spiro\">&nbsp;</div>".html_safe; end	
	def visible?(input) 	diamond if input; end 	
end
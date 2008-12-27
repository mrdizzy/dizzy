document.observe('dom:loaded', function() { 
	
	var footer_logos = $$('.footer_logo');
	footer_logos.each(function(s) { 
		var image = s.id.split('_');
		s.observe('mouseover', function() { 
			s.src = "/binaries/" + image[1] + ".png"
		})
		s.observe('mouseout', function() {
			s.src = "/binaries/" + image[1] + "/grey.png"
		})
	})		
})
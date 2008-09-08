module SlideShowHelper

  def slideshow(div_prefix,upto,wait)
    result = ""
    upto.times do |i|
      result = result + "'" + div_prefix + "_#{i}" + "'"
      unless i+1 == upto
        result = result + ","
      end
    end
        
     string = <<END_OF_STRING
    
       <script type="text/javascript">
          
         var slides = new Array(#{result});
         var i = 0;
         var wait = #{wait*1000};
        
          // the SlideShow function        
          function SlideShow() {        
            Effect.Fade(slides[i], { duration:1, from:1.0, to:0.0 });
            i++;
            if ((i) == #{upto}) i = 0;
            Effect.Appear(slides[i], { duration:1, from:0.0, to:1.0 });
          }
      
          // the event handler that starts the fading.        
          function startSlideshow() { setInterval('SlideShow()',wait); }        
          window.onload = startSlideshow();
        </script>
        
END_OF_STRING
  
    string
  
  end

end
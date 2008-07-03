xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0"){
  xml.channel{
    xml.title("Dizzy - Ruby On Rails")
    xml.link("http://www.dizzy.co.uk/")
    xml.description("Tutorials, cheatsheets, tips and more for the RoR framework.")
    xml.language('en-gb')
      for article in @latest
        xml.item do
          xml.title(article.title)
          xml.description(article.description)      
          xml.author(article.user.name) 
          xml.link(content_url(article.permalink))   
        end
      end
  }
}
module ApplicationHelper

    def article_link(object); link_to object.title, content_path(object.permalink); end

	def posted_in(categories, and_connector = true)
		and_connector = and_connector ? "<span class=\"amp\">&asp;</span>" : ", "
		categories.map! { |c| link_to(c.name.upcase, category_path(c.permalink)) }
		result = categories.to_sentence(:last_word_connector => and_connector, :two_words_connector => ", ")
		"<span class=\"posted_in\">" + result + "</span>"
	end
		
	def random_number(higher=4)	(higher * rand).to_i; end

	def administrator?() 		session[:administrator_id] ? true : false; end
	
end

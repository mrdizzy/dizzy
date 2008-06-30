module CommentsHelper

def prepare_comments(comments,result=Array.new, init=true, counter=0)
	counter = counter + 1
	comments.each do |comment|	
		
		next if comment.parent_id && init	
			
		if counter.even?
		result << "<div class=\"odd\" id=\"comment_#{comment.id}\">"
		else
			result << "<div class=\"normal\" id=\"comment_#{comment.id}\">"
		end
		
		result << "<div class=\"comments_left\"><p><span class=\"date\">#{time_ago_in_words(comment.created_at).upcase} AGO</span><br/> <span class=\"email\">#{comment.name}</span>" 
		
		if administrator? 
			result << "<br/><span class=\"email\">#{comment.email}</span>" 
		end
		
		result << "</div><div class=\"comments_right\"><h6>#{comment.subject}</h6>" 
		
		if administrator?  
			result << "<p>" + link_to(comment.content.title, content_path(:id => comment.content.permalink)) + "</p>"
		end
		
		result << "<p>#{comment.body}</p></div>" 
		
		if administrator?
			result << "<p>" + link_to_remote("Delete", :url => comment_path(:content_id => comment.content.id, :id => comment.id), :method => :delete) + "</p>"
		end
					
		result << 
		"<div class=\"reply_comment\" id=\"reply_#{comment.id}\">" + link_to_remote("Reply to this comment", :url => new_child_comment_path(:content_id => comment.content.id, :comment_id => comment.id), :method => :get)  + "</div><div id=\"reply_form_#{comment.id}\"></div>"
			
		prepare_comments(comment.children,result,false,counter) unless comment.children.empty?
					
		result << "</div>" if comment.children
	end
	result
end

end
module CommentsHelper

def prepare_comments(comments, result=Array.new, init=true, counter=0)
	counter = counter + 1
	comments.each do |comment|	
		result << "\n\n"
		next if comment.parent_id && init	
		if comment.parent_id?
			result << "<div class=\"single_comment\" id=\"comment_#{comment.id}\">"
		else
			result << "<div class=\"root_comment\" id=\"comment_#{comment.id}\">"
		end
		
		result << "<div class=\"comments_left\"><p><span class=\"posted_ago\">#{time_ago_in_words(comment.created_at).upcase} AGO</span><br/> <span class=\"email\">#{comment.name}</span></p>" 
		
		result << "<br/><span class=\"email\">#{comment.email}</span>" if administrator? 
			
		result << "</div><div class=\"comments_right\"><h6>#{comment.subject}</h6>" 
		
		result << "<p>" + link_to(comment.content.title, content_path(:id => comment.content.permalink)) + "</p>" if administrator? 
		
		result << "<p>#{comment.body}</p></div>" 
		
		result << "<p>" + link_to_remote("Delete", :url => comment_path(:content_id => comment.content.id, :id => comment.id), :method => :delete) + "</p>" if administrator? 
					
		result << 
		"<div class=\"reply_comment\" id=\"reply_#{comment.id}\"><p>" + diamond + " " + 
		link_to_remote("Reply to this comment", { :url => new_content_comment_child_comment_path(:content_id => comment.content.id, :comment_id => comment.id), :method => :get }, :href => "http://www.yahoo.com")  + 
		"</div><div id=\"reply_form_#{comment.id}\"></p></div>"
			
		prepare_comments(comment.children,result,false,counter) unless comment.children.empty?
					
		result << "</div>" if comment.children
	end
	result
end

end
module CommentsHelper

	def prepare_comments(comments,result=Array.new,counter=0)
		counter = counter + 1
		comments.each do |comment|			
			if counter.even?
			result << "<div class=\"odd\" id=\"comment_#{comment.id}\">"
			else
				result << "<div class=\"normal\" id=\"comment_#{comment.id}\">"
			end
			result << "<div class=\"comments_left\"><p><span class=\"date\">#{time_ago_in_words(comment.created_at).upcase} AGO</span></br> <span class=\"email\">#{comment.email}</span></div>" + 
			
			"<div class=\"comments_right\"><h6>#{comment.subject}</h6><p>#{comment.body}</p></div>" + 
			
			"<div class=\"reply_comment\" id=\"reply_#{comment.id}\">" + link_to_remote("Reply to this comment",{ :url => { :controller => "comments", :action => "reply", :id => comment.id} })  + "</div>"
						
				prepare_comments(comment.children,result,counter) unless comment.children.empty?
						
				result << "</div>" if comment.children
			end
		result	
	end

end

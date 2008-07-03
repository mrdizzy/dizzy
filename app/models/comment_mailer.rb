class CommentMailer < ActionMailer::Base
  
  def response(parent_comment,sent_at = Time.now)
    subject    "#{parent_comment.name}: a reply to your comment at dizzy.co.uk..."
    body       :parent_comment => parent_comment
    recipients parent_comment.email
    from       'david.pettifer@dizzy.co.uk'
  end  
  
  def notification(comment)
  	subject "A new comment has been received"
  	body		:comment => comment
  	recipients "david.pettifer@dizzy.co.uk"
  	from	"david.pettifer@dizzy.co.uk"
  	
  end
  
end

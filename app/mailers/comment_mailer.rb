class CommentMailer < ApplicationMailer
  
  def reply_notification(parent_comment,sent_at = Time.now)
    subject    "#{parent_comment.name}: a reply to your comment at dizzy.co.uk..."
    body       :parent_comment => parent_comment
    recipients parent_comment.email
    from       FROM_EMAIL
  end  
  
  def notification(comment)
  	subject comment.subject
  	body		:comment => comment
  	recipients "david.pettifer@dizzy.co.uk"
  	from	FROM_EMAIL
  end
  
end

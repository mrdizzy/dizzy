class CommentMailer < ActionMailer::Base
  
  def response(parent_comment,sent_at = Time.now)
    subject    "#{parent_comment.name}: a reply to your comment at dizzy.co.uk..."
    body       :parent_comment => parent_comment
    recipients parent_comment.email
    from       FROM_EMAIL
  end  
  
  def email_dizzy(comment,sent_at = Time.now)
  puts comment
  	subject comment.subject
  	
  	recipients "david.pettifer@dizzy.co.uk"
  	from	FROM_EMAIL
  end
  
end

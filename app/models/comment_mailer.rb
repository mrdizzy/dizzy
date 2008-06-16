class CommentMailer < ActionMailer::Base
  
  def response(parent_comment,sent_at = Time.now)
    subject    "#{parent_comment.name}: a reply to your comment at dizzy.co.uk..."
    body       :parent_comment => parent_comment
    recipients parent_comment.email
    from       'david.pettifer@dizzy.co.uk'
  end  
  
end

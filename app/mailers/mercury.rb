class Mercury < ApplicationMailer
    
  def new_message(message)
    subject    "dizzy.co.uk: A new message"
    body       :message => message
    recipients "david.pettifer@gmail.com"
    from       FROM_EMAIL
  end  

end

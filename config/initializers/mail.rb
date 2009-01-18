ActionMailer::Base.smtp_settings = {
	:address => "homie.mail.dreamhost.com",
	:port => 25,
	:domain => "intentional-stance.com",
	:authentication => :login,
	:user_name => "dreamhost@intentional-stance.com",
	:password => "^pw4i#Ew"
}

FROM_EMAIL = "david.pettifer@dizzy.co.uk"

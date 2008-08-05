ActionMailer::Base.smtp_settings = {
	:address => "www21.a2hosting.com",
	:domain => "dizzy.co.uk",
	:authentication => :login,
	:user_name => "dizzynew",
	:password => "beaslewig175"
}

FROM_EMAIL = "david.pettifer@dizzy.co.uk"

ExceptionNotifier.exception_recipients 	= %w(david.pettifer@googlemail.com)
ExceptionNotifier.sender_address		= "errors@dizzy.co.uk"
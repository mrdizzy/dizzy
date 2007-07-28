class Recipient < ActiveRecord::Base
	belongs_to :ticket
	belongs_to :email
end

class ToRecipient < Recipient
end

class CcRecipient < Recipient
end

class FromRecipient < Recipient
end
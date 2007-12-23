# == Schema Information
# Schema version: 6
#
# Table name: recipients
#
#  id        :integer(11)   not null, primary key
#  email_id  :integer(11)   
#  ticket_id :integer(11)   
#  type      :string(255)   
#

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

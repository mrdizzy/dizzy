class LoadPollsData < ActiveRecord::Migration
  def self.up
  	poll = Poll.create(:name => "How long have you used Ruby on Rails?")
  	option_a = Vote.create(:option => "What is Ruby on Rails?")
  	option_b = Vote.create(:option => "I've just started!")
  	option_c = Vote.create(:option => "Less than 6 months")
  	option_d = Vote.create(:option => "6 months to 1 year")
  	option_e = Vote.create(:option => "1 to 2 years")
  	option_f = Vote.create(:option => "2+ years")
  	poll.votes = [option_a, option_b, option_c, option_d, option_e, option_f]
  end

  def self.down
  	Poll.delete_all
  	Vote.delete_all
  end
end

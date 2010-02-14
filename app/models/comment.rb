class Comment < ActiveRecord::Base

	belongs_to :content
   
	acts_as_tree :order => "subject"
	
	validates_presence_of :name, :email, :body, :subject, :content_id
   validates_existence_of :parent, :allow_nil => true
   validates_existence_of :content, :allow_nil => true
	validates_format_of :email, :with => /^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i, :message => "must contain a valid address", :allow_blank => true
   
   after_save :send_email_notification
	
	named_scope :new_comments, :conditions => { :new => true }, :order => "created_at DESC"

   def validate
  		if self.parent
         unless self.content_id == self.parent.content_id
            errors.add :content_id, "must be tied to the same content as parent comment"
         end
      end
	end 
   
   def body_to_markdown		
      result = "Use numbered headers: false
HTML use syntax: true

{:rhtml: lang=rhtml html_use_syntax=true}
{:ruby: lang=ruby  html_use_syntax=true}
{:plaintext: lang=plaintext html_use_syntax=true}
" << body
Maruku.new(result).to_html
end
   private
   
   def send_email_notification
      CommentMailer.deliver_notification(self)	
   end
end

# == Schema Info
# Schema version: 20090919133116
#
# Table name: comments
#
#  id         :integer(4)      not null, primary key
#  content_id :integer(4)      not null, default(0)
#  parent_id  :integer(4)
#  body       :text
#  email      :string(255)
#  name       :string(255)
#  new        :boolean(1)      default(TRUE)
#  subject    :string(255)
#  created_at :datetime
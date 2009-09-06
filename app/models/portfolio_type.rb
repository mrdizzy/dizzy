class PortfolioType < ActiveRecord::Base

  default_scope :order => :description
	
  attr_accessor :content_type, :size

	has_many 					:portfolio_items, :dependent => :destroy

	validates_presence_of		   :description, :column_space
	validates_presence_of		   :position, :unless => Proc.new { |portfolio_type| portfolio_type.visible == false }
  
  validates_uniqueness_of 	      :description
  validates_uniqueness_of		  :position, :allow_blank => true
  
  validates_format_of :content_type, :with => /image\/png/, :message => "must be a PNG file"
  
	validates_inclusion_of :size, :in => 1.kilobyte..20.kilobytes, :message => "must be between 1k and 20k"
  
	validates_inclusion_of		  :column_space, :in => 1..3, :message => "should be between 1 and 3"
	validates_numericality_of 	:position, :allow_blank => true
   

  attr_accessor :content_type, :size
  
	def uploaded_data=(binary_data)
    
		unless binary_data.blank?
		  self.content_type    = binary_data.content_type
		  self.size            = binary_data.size
		  self.header_binary = binary_data.read
		end	
	end
end

# == Schema Info
# Schema version: 20090827143534
#
# Table name: portfolio_types
#
#  id            :integer(4)      not null, primary key
#  column_space  :integer(4)
#  description   :string(40)
#  header_binary :binary
#  position      :integer(4)
#  visible       :boolean(1)      default(TRUE)
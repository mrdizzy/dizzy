# == Schema Information
# Schema version: 20081216175905
#
# Table name: portfolio_types
#
#  id            :integer(4)    not null, primary key
#  description   :string(40)    
#  column_space  :integer(4)    
#  position      :integer(4)    
#  header_binary :binary        
#  visible       :boolean(1)    default(TRUE)
#

class PortfolioType < ActiveRecord::Base
	validates_presence_of		:description, :column_space
	validates_presence_of		:position, :unless => Proc.new { |portfolio_type| portfolio_type.visible == false }
	validates_uniqueness_of 	:description
	validates_uniqueness_of		:position, :allow_blank => true
	validates_inclusion_of		:column_space, :in => 0..3,:message => "should be between 0 and 3"
	validates_numericality_of 	:position,:allow_blank => true
	has_many 					:portfolio_items, :dependent => :destroy
	
	def uploaded_data=(binary_data)
			unless binary_data.blank?
			self.header_binary = binary_data.read
		end
	end	
end

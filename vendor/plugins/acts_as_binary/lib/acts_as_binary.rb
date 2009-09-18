module ActsAsBinary

  def self.extended(base)
	  class << base
		alias_method_chain :inherited, :file_uploads
	  end
  end
  
  def inherited_with_file_uploads(base)
    unless base.class_name == "Session"
      base.columns.map { |c| c if c.type == :binary }.compact.each do |col|
      method_name = col.name.gsub("_binary_data", "")
      base.class_eval <<-EOV
        def #{method_name}=(input)                                     	  # def image=(input)			
        unless input.blank?                                       		  #   unless input.blank?
          self.#{method_name}_filename = input.original_filename          #     self.image_filename = input.original_filename
          self.#{method_name}_content_type = input.content_type           #     self.image_content_type = input.content_type
          self.#{method_name}_binary_data = input.read               	  #     self.image_binary_data = input.read
          
        end                                                       		  #   end
        
        end      
      EOV
      end
    end
    inherited_without_file_uploads(base)
  end
end
module HasBinary

  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def has_binary(*attr_names)
    
      configuration = { :on => :save }
      configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)

      attr_names.each do |attr_name|
        send(validation_method(configuration[:on])) do |record|
          blank = record.send("#{attr_name}_binary_data").blank?
          unless configuration[:allow_blank]
            record.errors.add(attr_name, "can't be blank") if blank
            if configuration[:content_type] && !blank
              unless record.send("#{attr_name}_content_type") =~ configuration[:content_type]
              record.errors.add("#{attr_name}_content_type".to_sym, :invalid)
            end
            if configuration[:size] && !blank
              size = record.send("#{attr_name}_binary_data").size
              unless configuration[:size].include?(size)
                error_message = "should be between #{configuration[:size].first} and #{configuration[:size].last} bytes, but is #{size} bytes"
                record.errors.add(attr_name, error_message)
              end
            end
          end
        end
      end
      attr_names.each do |attr_name|
        class_eval <<-EOV
          def #{attr_name}=(input)                                     	# def image=(input)	
            unless input.blank?                                       		  #   unless input.blank?
              self.#{attr_name}_filename = input.original_filename        #     self.image_filename = input.original_filename
              self.#{attr_name}_content_type = input.content_type         #     self.image_content_type = input.content_type
              self.#{attr_name}_binary_data = input.read               	  #     self.image_binary_data = input.read
            end                                                       		  #   end
          end      
        EOV
      end
     
    end
      
    end
  end
end
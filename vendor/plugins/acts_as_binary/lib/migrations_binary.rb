module MigrationsBinary

  def self.included(base)
    base.send(:include, InstanceMethods)
    base.alias_method_chain :column, :binary
  end

  module InstanceMethods
    def column_with_binary(name, type, options = {})
      if type.to_sym == :binary
        column_without_binary("#{name}_binary_data", 'binary', options)
        column_without_binary("#{name}_content_type", 'string', options)
        column_without_binary("#{name}_filename", 'string', options)
      else
        column_without_binary(name, type, options) 
      end
    end       
  end
end

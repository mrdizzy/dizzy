module MigrationsBinary

  def self.included(base)
    base.send(:include, InstanceMethods)
  end

  module InstanceMethods
    def file(*args)
      options = args.extract_options!
      column_names = args
      column_names.each do |col|
        column("#{col}_binary_data", 'binary', options)
        column("#{col}_content_type", 'string')
        column("#{col}_filename", 'string')
      end
    end       
  end
end

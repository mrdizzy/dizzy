module RenderBinary
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.alias_method_chain :render, :binary
  end
  module InstanceMethods
    def render_with_binary(options = nil, extra_options = {}, &block)
      if options == :binary
        object, attribute = *extra_options.to_a.flatten
        send_data(object.send("#{attribute}_binary_data"), 
                  :type => object.send("#{attribute}_content_type"), 
                  :filename => object.send("#{attribute}_filename"),
                  :disposition => 'inline')
      else
        render_without_binary(options, extra_options, &block)
      end
    end  
  end
end
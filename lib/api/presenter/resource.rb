module Api
  module Presenter
    class Resource
      def initialize(resource)
        @resource = resource
      end
  
      def method_missing(method, *args, &block)
        allowed_methods = self.class.hypermedia_properties[:simple].concat self.class.hypermedia_properties[:resource]
    
        if allowed_methods.include? method
          @resource.send(method, *args, &block)
        else
          super
        end
      end
  
      def links(options = {})
        links = {}

        self.methods.grep(/_link$/).each do |link_method|
          link_name = link_method.to_s.split("_").first
          links[link_name] = { "href" => self.send(link_method) } if self.send(link_method.to_s + "?", options)
        end
    
        links
      end
  
      def self_link?(options = {})
        true
      end
    end
  end
end

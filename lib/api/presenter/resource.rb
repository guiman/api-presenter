module Api
  module Presenter
    class Resource
      def initialize(resource)
        @resource = resource
      end

      class << self
        def property(value)
          properties << value unless properties.include? value
        end

        def properties
          @properties ||= []
        end
        
        def host
          @@host ||= ''
        end
        
        def host=(v)
          @@host = v
        end

        def inherited(subclass)
          (subclass.properties << properties).flatten!
        end
      end

      def method_missing(method, *args, &block)
        if self.class.properties.include? method
          @resource.send(method, *args, &block)
        else
          super
        end
      end

      def links(options = {})
        links = {}

        self.methods.grep(/_link$/).each do |link_method|
          link_name = link_method.to_s.split("_").first
          links[link_name] = { "href" => "#{self.class.host}#{self.send(link_method)}" } if self.send(link_method.to_s + "?", options)
        end

        links
      end

      def self_link?(options = {})
        true
      end
      
      def present
        Api::Presenter::Hypermedia.present self
      end
    end
  end
end

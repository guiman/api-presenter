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

        def link(name, value, &condition)
          condition = Proc.new { true } unless block_given?

          links[name] = { value: value, condition: condition }
        end

        def links
          @links ||= {}
        end

        def host
          @@host ||= ''
        end

        def host=(v)
          @@host = v
        end

        def prefix
          @@prefix ||= ''
        end

        def prefix=(v)
          @@prefix = v
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

      def build_links(options = {})
        links = {}

        self.class.links.each do |link_name, link_value|
          link_actual_value = link_value[:value].dup

          # retrieve stubs to replace looking for {{method_to_call}}
          stubs = link_actual_value.scan(/\{\{(\w+)\}\}/).flatten

          # now we replace them
          stubs.each{ |stub| link_actual_value.gsub!(/\{\{#{stub}\}\}/, self.send(stub.to_sym).to_s) }

          # and finish the url
          links[link_name.to_s] = { "href" => "#{self.class.host}#{self.class.prefix}#{link_actual_value}" } if link_value[:condition].call(options)
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

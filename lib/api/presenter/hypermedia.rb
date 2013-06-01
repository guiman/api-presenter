module Api
  module Presenter
    class Hypermedia
      def self.present(resource)
        # Initialize representation with links
        representation = build_links resource

        present_properties resource, representation

        MultiJson.dump representation
      end

      # Process basic information from the resource such as
      # simlple fields(Dates, numbers, etc.) and also more
      # complex ones that may be subject of expansion.
      def self.present_properties(resource, representation)
        properties = resource.class.hypermedia_properties

        present_simple_properties resource, properties, representation

        present_resource_properties resource, properties, representation
      end

      def self.present_simple_properties(resource, properties, representation)
        entries_property = properties[:simple].delete(:entries)

        if entries_property
          representation[entries_property.to_s] = []
          resource.send(entries_property).each do |nested_resource|
            representation[entries_property.to_s] << nested_resource.to_resource.links(embed: true)
          end
        end

        properties[:simple].each do |property|
          representation[property.to_s] = resource.send(property)
        end
      end

      def self.present_resource_properties(resource, properties, representation)
        properties[:resource].each do |property|
          relation = resource.send(property)
          relation_resource = (relation.kind_of? Resource) ? relation : relation.to_resource
          representation["links"][property.to_s] = relation_resource.links(embed: resource.kind_of?(CollectionResource))
          representation["links"][property.to_s] = representation["links"][property.to_s]["self"] if representation["links"][property.to_s]["self"]
        end
      end

      def self.build_links(resource, options = {})
        { "links" => resource.links(options) }
      end
    end
  end
end

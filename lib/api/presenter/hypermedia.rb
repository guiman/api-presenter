module Api
  module Presenter
    class Hypermedia
      class << self
        def present(resource)
          # Initialize representation with links
          representation = build_links resource

          present_properties resource, representation

          representation
        end

        # Process basic information from the resource such as
        # simlple fields(Dates, numbers, etc.) and also more
        # complex ones that may be subject of expansion.
        def present_properties(resource, representation)
          resource_properties = resource.class.properties.dup
          
          # entries property receives special treatment
          present_entries_property resource, representation, resource_properties if resource_properties.include? :entries
                    
          # Now the other muggles
          resource_properties.each do |property_name|
            property_value = resource.send(property_name)
            
            if property_value.kind_of?(Resource) || property_value.respond_to?(:to_resource)
              # Resource like properties
              present_resoure_property property_name, property_value, resource, representation
            else
              # Non-Resource like properties
              representation[property_name.to_s] = property_value
            end
          end
        end
        
        def present_entries_property(resource, representation, resource_properties)
          entries_property = resource_properties.delete(:entries)

          representation[entries_property.to_s] = []

          resource.send(entries_property).each do |nested_resource|
            representation[entries_property.to_s] << build_links(nested_resource.to_resource, embed: true)
          end
        end
        
        def present_resoure_property(property_name, property_value, resource, representation)
          property_value = property_value.to_resource if property_value.respond_to? :to_resource
          
          representation["links"][property_name.to_s] = property_value.build_links(embed: resource.kind_of?(CollectionResource))

          # we only need the "self" contents
          representation["links"][property_name.to_s] = representation["links"][property_name.to_s]["self"] if representation["links"][property_name.to_s]["self"]                        
        end

        def build_links(resource, options = {})
          { "links" => resource.build_links(options) }
        end
      end
    end
  end
end

module Api
  module Presenter
    class CollectionResource < Resource  
      def self.hypermedia_properties
        {
          simple:  [:offset, :limit, :total,:entries],
          resource: []
        }
      end
  
      def entries
        @resource
      end
    end
  end
end

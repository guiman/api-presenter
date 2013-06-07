module Api
  module Presenter
    class SearchResource < CollectionResource
      attr_reader :query
      
      def initialize(resource, query)
        @resource = resource
        @query = query
      end

      property :query

      def query_string
        result = self.class.hypermedia_query_parameters.inject([]) { |col, query_parameter| col << "query[#{query_parameter}]=#{@query[query_parameter]}" }
        "?" + result.join("&")
      end
    end
  end
end

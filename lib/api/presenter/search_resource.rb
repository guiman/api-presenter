module Api
  module Presenter
    class SearchResource < CollectionResource
      attr_reader :query

      property :query

      def initialize(resource, query)
        @resource = resource
        @query = query
      end


      def query_string
        result = self.class.hypermedia_query_parameters.inject([]) { |col, query_parameter| col << "query[#{query_parameter}]=#{@query[query_parameter]}" }
        "?" + result.join("&")
      end
      
      def build_links(options = {})
        links = super

        # this adds the query string
        links.each do |link_name, link_value|
          links[link_name]['href'] = "#{link_value['href']}#{query_string}"
        end

        links
      end
    end
  end
end

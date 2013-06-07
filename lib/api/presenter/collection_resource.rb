module Api
  module Presenter
    class CollectionResource < Resource

      property :offset
      property :limit
      property :total
      property :entries

      def entries
        @resource
      end
    end
  end
end

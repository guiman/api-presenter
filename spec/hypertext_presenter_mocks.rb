module HypertextPresenterMocks
  class MockData
    attr_accessor :number, :string, :date
  
    def initialize(attributes = {})
      @number = attributes[:number]
      @string = attributes[:string]
      @date = attributes[:date]
    end
  
    def to_resource
      MockSingleResource.new(self)
    end
  end

  class Collection
    def initialize(arr)
      @arr = arr
    end
  
    def offset
      0
    end
  
    def limit
      15
    end
  
    def total
      @arr.count
    end
  
    def each(&block)
      @arr.each &block
    end
  end

  class MockSingleResource < Api::Presenter::Resource
    property :number
    property :string
    property :date
    property :sibling
    
    link "self", "/path/to/single_resource/{{number}}"
    link("custom", "/path/to/custom_link") { |options = {}| options[:embed].nil? || !options[:embed] }
  
    def sibling
      MockSingleResource.new(MockData.new(number: 20, string: "I'm a sibling of someone", date: (Date.today + 1)))
    end
  end

  class MockCollectionResource < Api::Presenter::CollectionResource
    link "self", "/path/to/collection_resource"
  end

  class MockSearchResource < Api::Presenter::SearchResource
    def self.hypermedia_query_parameters
      ["page", "param1","param2"]
    end

    link "self", "/path/to/search_resource"

    def current_page
      1
    end
  end
end

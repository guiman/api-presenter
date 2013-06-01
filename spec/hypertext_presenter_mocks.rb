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
    def self.hypermedia_properties
      {
       simple: [:number, :string, :date],
       resource: [:sibling]
      }
    end
  
    def self_link
      "/path/to/single_resource/#{@resource.number}"
    end
  
    def custom_link
      "/path/to/custom_link"
    end
  
    def custom_link?(options = {})
      options[:embed].nil? || !options[:embed]
    end
  
    def sibling
      MockSingleResource.new(MockData.new(number: 20, string: "I'm a sibling of someone", date: (Date.today + 1)))
    end
  end

  class MockCollectionResource < Api::Presenter::CollectionResource
    def self_link
      "/path/to/collection_resource"
    end
  end

  class MockSearchResource < Api::Presenter::SearchResource
    def self.hypermedia_query_parameters
      ["page", "param1","param2"]
    end
  
    def self_link
      "/path/to/search_resource#{query_string}"
    end
  
    def current_page
      1
    end
  end
end
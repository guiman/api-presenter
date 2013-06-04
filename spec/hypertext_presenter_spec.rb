require_relative './spec_helper'
require_relative './hypertext_presenter_mocks'

include HypertextPresenterMocks

describe Api::Presenter::Hypermedia do
  let(:collection_resource_standard)do
    {
      "links" =>
      {
        "self" =>
        {
          "href" => "/path/to/collection_resource"
        }
      },

      "offset" => 0,
      "limit" => 15,
      "total" => 4,

      "entries" =>
      [
        {
          "links" =>
          {
            "self" =>
            {
              "href" => "/path/to/single_resource/1"
            }
          }
        },
        {
          "links" =>
          {
            "self" =>
            {
              "href" => "/path/to/single_resource/2"
            }
          }
        },
        {
          "links" => 
          {
            "self" =>
            {
              "href" => "/path/to/single_resource/3"
            }
          }
        },
        {
          "links" =>
          {
            "self" =>
            {
              "href" => "/path/to/single_resource/4"
            }
          }
        }
      ]
    }
  end
  let(:single_resource_standard) do
    {
      "links" =>
      {
        "self" =>
        {
          "href" => "/path/to/single_resource/1"
        },
        "custom" =>
        {
          "href" => "/path/to/custom_link"
        },
        "sibling" =>
        {
          "href" => "/path/to/single_resource/20"
        }
      },
      "number" => 1,
      "string" => 'This is a string',
      "date" => Date.today.to_s
    }
  end
  let(:search_resource_standard)do
    {
      "links" =>
      {
        "self" =>
        {
          "href" => "/path/to/search_resource?query[page]=1&query[param1]=1&query[param2]=string"
        }
      },

      "offset" => 0,
      "limit" => 15,
      "total" => 4,
      
      "query" =>
      {
        "page" => 1,
        "param1" => 1,
        "param2" => "string"
      },

      "entries" =>
      [
        {
          "links" =>
          {
            "self" =>
            {
              "href" => "/path/to/single_resource/1"
            }
          }
        },
        {
          "links" =>
          {
            "self" =>
            {
              "href" => "/path/to/single_resource/2"
            }
          }
        },
        {
          "links" => 
          {
            "self" =>
            {
              "href" => "/path/to/single_resource/3"
            }
          }
        },
        {
          "links" =>
          {
            "self" =>
            {
              "href" => "/path/to/single_resource/4"
            }
          }
        }
      ]
    }
  end
  
  describe "when presenting a single resource" do
    
    let(:mock_data) { MockData.new(number: 1, string: 'This is a string', date: Date.today) }
    let(:single_resource){ MockSingleResource.new mock_data }
    let(:presented_single_resource){ Api::Presenter::Hypermedia.present single_resource }
    
    it "must respect the standard" do
      MultiJson.load(presented_single_resource).must_equal single_resource_standard
    end    
  end

  describe "presenting a collection resource" do
    
    let(:mock_data_collection) do
      collection = []
      4.times { |number| collection << MockData.new(number: number + 1, string: 'This is a string', date: Date.today) }
      Collection.new(collection)
    end
    
    let(:collection_resource){ MockCollectionResource.new mock_data_collection }
    
    let(:presented_collection_resource){ Api::Presenter::Hypermedia.present collection_resource }

    it "must respect the standard" do
      MultiJson.load(presented_collection_resource).must_equal collection_resource_standard
    end
    
    describe "presenting a search resource" do
      let(:search_resource){ MockSearchResource.new mock_data_collection, "page" => 1, "param1" => 1, "param2" => "string" }
      let(:presented_search_resource){ Api::Presenter::Hypermedia.present search_resource }
    
      it "must respect the standard" do
        MultiJson.load(presented_search_resource).must_equal search_resource_standard
      end
    end
  end
end

module EbayFindingApi
  class Client

    module CompletedItems

      def find_completed_items(opts = {})
        response = get('findCompletedItems', keywords: '9350 qhd')
        
        body = response.body[:findCompletedItemsResponse]
        puts body.inspect#.first[:searchResult].first[:item].inspect
      end

    end
  end
end
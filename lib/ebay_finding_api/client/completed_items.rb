module EbayFindingApi
  class Client

    module CompletedItems

      def find_completed_items(opts = {})
        response = get('findCompletedItems', keywords: '0718079183')
        puts response.body.inspect
      end

    end
  end
end
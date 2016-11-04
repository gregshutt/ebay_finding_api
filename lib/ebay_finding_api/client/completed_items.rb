module EbayFindingApi
  class Client

    module CompletedItems

      def find_completed_items(opts = {})
        get('findCompletedItems', keywords: '9350 qhd')
      end

    end
  end
end
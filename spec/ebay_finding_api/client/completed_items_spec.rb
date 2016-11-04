require 'spec_helper'

describe EbayFindingApi::Client::CompletedItems, :vcr do

  describe '#find_completed_items' do
    it 'works' do
      client = EbayFindingApi::Client.new ebay_app_id
      client.find_completed_items()
    end
  end

end
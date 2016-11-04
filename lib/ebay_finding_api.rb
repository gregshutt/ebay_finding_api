require 'ebay_finding_api/version'
require 'ebay_finding_api/client'

module EbayFindingApi

  def self.client
    EbayFindingApi::Client.new() 
  end

end
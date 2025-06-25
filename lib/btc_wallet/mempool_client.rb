require 'rest-client'

module BtcWallet
  class MempoolClient
    attr_reader :base_addr
    def initialize(base_addr)
      @base_addr = base_addr
    end

    def address_info(address)
      resp = RestClient.get("#{base_addr}/address/#{address}")
      data = JSON.parse(resp)
    end

    def utxos(address)
      resp = RectClient.get("#{base_addr}/#{address}/utxo")
      JSON.parse(resp)
    end
  end
end

require "rest-client"

module BtcWallet
  class MempoolClient
    attr_reader :base_addr

    def initialize(base_addr)
      @base_addr = base_addr
    end

    def address_info(address)
      resp = RestClient.get("#{base_addr}/address/#{address}")
      JSON.parse(resp.body)
    end

    def utxos(address)
      resp = RectClient.get("#{base_addr}/#{address}/utxo")
      JSON.parse(resp.body)
    end

    def broadcast(hex)
      resp = RestClient.post(
        "#{base_addr}/tx",
        hex,
        {content_type: "text/plain"}
      )
      JSON.parse(resp.body)
    end
  end
end

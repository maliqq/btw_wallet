require "rest-client"

module BtcWallet
  class MempoolClient
    DUST_ERROR_RESPONSE = 'sendrawtransaction RPC error: {"code":-26,"message":"dust"}'
    attr_reader :base_addr

    def initialize(base_addr)
      @base_addr = base_addr
    end

    def address_info(address)
      resp = RestClient.get("#{base_addr}/address/#{address}")
      JSON.parse(resp.body)
    end

    def utxos(address)
      resp = RestClient.get("#{base_addr}/address/#{address}/utxo")
      JSON.parse(resp.body)
    end

    def broadcast(tx)
      resp = RestClient.post(
        "#{base_addr}/tx",
        tx.to_hex,
        {content_type: "text/plain"}
      )
      resp.body
    rescue RestClient::BadRequest => e
      raise AmountTooSmall, "Amount is too small for tx: #{tx.to_h.inspect}" if e.response.body == DUST_ERROR_RESPONSE
    end
  end
end

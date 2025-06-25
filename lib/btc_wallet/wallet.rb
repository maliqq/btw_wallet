# frozen_string_literal: true

module BtcWallet
  class Wallet
    extend StoreMethods
    include SendMethods

    attr_reader :key, :mempool_client, :logger
    # @param key [Bitcoin::Key]
    def initialize(key, mempool_client:, logger:)
      @key = key
      @mempool_client = mempool_client
      @logger = logger
    end

    def address
      key.to_p2wpkh
    end

    def balance
      data = mempool_client.address_info(address)

      data.dig('chain_stats', 'funded_txo_sum') - data.dig('chain_stats', 'spent_txo_sum')
    end

    def send_amount(to_address, amount)
      selected_utxos, total_in = prepare_utxos
      change = total_in - amount - fee

      tx = Bitcoin::Tx.new

      add_inputs(tx, selected_utxos)
      add_output(tx, to_address, amount)
      add_change_output(tx, address) if change > 0

      result = sign_inputs(tx, selected_utxos)

      logger.info(result.to_json)
    end

    private

    def utxos
      mempool_client.utxos(address)
    end
  end
end

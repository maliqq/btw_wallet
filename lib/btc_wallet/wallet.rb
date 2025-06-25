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

    def utxos
      mempool_client.utxos(address)
    end

    def send_amount(to_address, amount)
      selected_utxos, total_in = prepare_utxos
      change = total_in - amount - fee

      tx = Bitcoin::Tx.new
      selected_utxos.each do |utxo|
        tx_in = Bitcoin::TxIn.new(
          Bitcoin::OutPoint.new(utxo['txid'].rhex, utxo['vout']),
          ''
        )
        tx.add_txin(tx_in)
      end
    end
  end
end

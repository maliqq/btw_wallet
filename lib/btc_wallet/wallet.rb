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

      data.dig("chain_stats", "funded_txo_sum") - data.dig("chain_stats", "spent_txo_sum")
    end

    def send_amount(to_address, amount, fee = ::BtcWallet::DEFAULT_FEE)
      selected_utxos, total_in = prepare_utxos(amount, fee)
      change = total_in - amount - fee

      Bitcoin::Tx.new.tap do |tx|
        add_inputs(tx, selected_utxos)

        add_output(tx, to_address, amount)
        add_output(tx, address, change) if change > 0

        sign_inputs(tx, selected_utxos)
      end
    end

    def send_and_broadcast(to_address, amount)
      send_amount(to_address, amount).tap do |tx|
        mempool_client.broadcast(tx)
        logger.info("Broadcasted tx: #{tx.to_hex}")
      end
    end

    private

    def utxos
      mempool_client.utxos(address).tap do |list|
        raise NoUTXOsAvailable, "No UTXOs available" if list.empty?
      end
    end
  end
end

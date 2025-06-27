# frozen_string_literal: true

require_relative "btc_wallet/version"

require "rest-client"
require "bitcoin"
require "active_support/all"

Bitcoin.chain_params = :signet

module BtcWallet
  class Error < StandardError; end

  class InsufficientBalance < Error; end

  class NoUTXOsAvailable < Error; end

  class AmountTooSmall < Error; end

  DEFAULT_MEMPOOL_BASE_ADDR = "https://mempool.space/signet/api/"
  DEFAULT_FEE = 1_000 # satoshi

  autoload :Wallet, "btc_wallet/wallet"
  autoload :MempoolClient, "btc_wallet/mempool_client"
  autoload :StoreMethods, "btc_wallet/store_methods"
  autoload :SendMethods, "btc_wallet/send_methods"
end

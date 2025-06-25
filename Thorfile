require 'em/pure_ruby' # FIXME

require 'dotenv'
require 'pp'
require 'pry'

Dotenv.load(".env.local", ".env")

require 'btc_wallet'

module BtwWallet
  class Main < Thor
    include Thor::Actions

    namespace :btc

    desc 'create', 'Create a test address'
    def create
      store = BtcWallet::Wallet.create_default!

      puts "Signet address: #{store.address}"
    end

    desc 'balance', 'Show current balance in sats for a wallet'
    def balance
      store = BtcWallet::Wallet.load_default!

      puts "Balance for #{store.address}: #{store.balance}"
    end

    desc 'send ADDRESS --amount <amount>', 'Send amount to specific address'
    method_option :amount, aliases: "-n", type: :numeric, required: true, desc: "Amount in sats"
    def send(address)

    end
  end
end

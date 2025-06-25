require 'em/pure_ruby' # FIXME
require 'bitcoin'

module BtwWallet
  class Main < Thor
    namespace :btc

    desc 'create', 'Create a test sBTC address'
    def create
      Bitcoin.chain_params = :testnet
      key = Bitcoin::Key.generate

      name = `whoami`.strip

      File.write("priv/#{name}.wif", key.to_wif)
      FileUtils.chmod(0600, "priv/#{name}.wif")
      File.write("priv/#{name}.pub", key.pubkey)
      FileUtils.chmod(0644, "priv/#{name}.pub")
    end

    desc 'balance', 'Show current balance in sBTC'
    def balance
    end

    desc 'send', 'Send amount to specific sBTC address'
    def send(address, amount)
    end
  end
end

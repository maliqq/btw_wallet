# frozen_string_literal: true

module BtcWallet
  module StoreMethods
    WALLET_DIR_ENV = "WALLET_DIR"
    WALLET_NAME_ENV = "WALLET_NAME"

    # defaults
    def default_dir
      ENV.fetch(WALLET_DIR_ENV) { File.expand_path("../../priv", __dir__) }
    end

    def default_name
      ENV.fetch(WALLET_NAME_ENV) { Etc.getlogin }
    end

    def default_logger
      Logger.new($stdout)
    end

    def default_mempool_client
      MempoolClient.new(
        ENV.fetch("MEMPOOL_API_BASE_ADDR", DEFAULT_MEMPOOL_BASE_ADDR)
      )
    end

    def create_default!
      new(
        create_key(
          default_dir,
          default_name
        ),
        mempool_client: default_mempool_client,
        logger: default_logger
      )
    end

    def load_default!
      new(
        load_key(
          default_dir,
          default_name
        ),
        mempool_client: default_mempool_client,
        logger: default_logger
      )
    end

    # keys
    def create_key(dir, name)
      Bitcoin::Key.generate.tap do |key|
        dir.join("#{name}.key").tap do |f|
          File.write(f, key.to_wif)
          FileUtils.chmod(0o600, f)
        end

        dir.join("#{name}.pub").tap do |f|
          File.write(f, key.pubkey)
          FileUtils.chmod(0o644, f)
        end
      end
    end

    def load_key(dir, name)
      key_path = dir.join("#{name}.key")
      unless File.exist?(key_path)
        raise "Key file not found: #{key_path}"
      end
      Bitcoin::Key.from_wif(File.read(key_path).strip)
    end
  end
end

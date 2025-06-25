# frozen_string_literal: true

module BtcWallet
  module StoreMethods
    def default_dir
      Pathname.new(__dir__).join('../../priv').expand_path
    end

    def default_name
      `whoami`.strip
    end

    def default_logger
      Logger.new($stdout)
    end

    def create_default!
      create_wallet(
        default_dir,
        default_name,
        logger: default_logger
      )
    end

    def load_default!
      load_wallet(
        default_dir,
        default_name,
        logger: default_logger
      )
    end

    def create_wallet(dir, name, logger: )
      key = Bitcoin::Key.generate

      dir.join("#{name}.key").tap do |f|
        File.write(f, key.to_wif)
        FileUtils.chmod(0600, f)
      end

      dir.join("#{name}.pub").tap do |f|
        File.write(f, key.pubkey)
        FileUtils.chmod(0644, f)
      end

      new(key, logger:)
    end

    def load_wallet(dir, name, logger:)
      key = Bitcoin::Key.from_wif(File.read(dir.join("#{name}.key")).strip)
      new(key, logger:)
    end
  end
end

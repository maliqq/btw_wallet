# frozen_string_literal: true

module BtcWallet
  module SendMethods
    def prepare_utxos(fee = ::BtcWallet::DEFAULT_FEE)
      selected_utxos = []
      total_in = 0

      utxos.each do |utxo|
        selected_utxos << utxo
        total_in += utxo['value']
        break if total_in >= amount + fee
      end

      [selected_utxos, total_in]
    end
  end
end

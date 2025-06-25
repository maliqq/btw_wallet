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

    def add_output(tx, to_address, amount)
      script_pubkey = Bitcoin::Script.parse_from_addr(to_address)
      tx_out = Bitcoin::TxOut.new(amount, script_pubkey)
      tx.add_txout(tx_out)
    end

    def add_change_output(tx, from_address, amount)
      change_script = Bitcoin::Script.parse_from_addr(from_address)
      tx.add_txout(Bitcoin::TxOut.new(amount, change_script))
    end

    def sign_inputs(tx, selected_utxos)
      selected_utxos.each_with_index do |utxo, i|
        sighash = tx.sighash_for_witness(i, Bitcoin::Script.parse_from_addr(from_address), utxo['value'], Bitcoin::SIGHASH_TYPE[:all])
        signature = key.sign(sighash) + [Bitcoin::SIGHASH_TYPE[:all]].pack('C')
        witness = Bitcoin::Witness.new
        witness.stack << signature
        witness.stack << key.pubkey
        tx.txins[i].witness = witness
      end
    end
  end
end

# frozen_string_literal: true

module BtcWallet
  module SendMethods
    def prepare_utxos(amount, fee)
      selected_utxos = []
      total_in = 0

      utxos.each do |utxo|
        selected_utxos << utxo
        total_in += utxo["value"]
        break if total_in >= amount + fee
      end

      if total_in < amount + fee
        raise InsufficientBalance, "Insufficient balance (required #{amount + fee}, have #{total_in})"
      end

      [selected_utxos, total_in]
    end

    def add_inputs(tx, selected_utxos)
      selected_utxos.each do |utxo|
        tx_in = Bitcoin::TxIn.new(
          out_point: Bitcoin::OutPoint.new(utxo["txid"].rhex, utxo["vout"])
        )
        tx.in << tx_in
      end
    end

    def add_output(tx, address, amount)
      script_pubkey = Bitcoin::Script.parse_from_addr(address)
      tx.out << Bitcoin::TxOut.new(value: amount, script_pubkey:)
    end

    def sign_inputs(tx, selected_utxos)
      selected_utxos.each_with_index do |utxo, i|
        sighash = tx.sighash_for_input(i, Bitcoin::Script.parse_from_addr(address), amount: utxo["value"])
        signature = key.sign(sighash) + [Bitcoin::SIGHASH_TYPE[:all]].pack("C")

        witness = Bitcoin::ScriptWitness.new
        witness.stack << signature
        witness.stack << key.pubkey

        tx.in[i].script_witness = witness
      end
    end
  end
end

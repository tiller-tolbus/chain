|%
++  addr  @ux
++  txn-signed  [signature=@ux txn-unsigned]
++  txn-unsigned
  $:  who=addr
      nonce=@ud
      app=@tas
      ::  fees are ignored for now
      fee=@ud
      cmd=ledger-cmd
  ==
++  balances  (map addr @ud)
++  ledger-cmd
  $%  [%send target=addr amount=@ud]
      [%faucet ~]
  ==
--

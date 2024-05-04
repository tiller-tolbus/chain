/-  ch=chain
|%
++  txn-ledger
  $:  signature=@
      txn-unsigned-ledger
  ==
++  txn-unsigned-ledger
  $:  who=addr:ch
      nonce=@ud
      txn-stub-ledger
  ==
++  txn-stub-ledger
  $:  app=%ledger
      ::  fees are ignored for now
      fee=@ud
      cmd=ledger-cmd
  ==
++  internal-balance
  $:  balance=@ud
      nonce=@ud
      faucet=?
  ==
++  internal-balances  (map addr:ch internal-balance)
++  balances  (map addr:ch @ud)
++  ledger-cmd
  $%  [%send target=addr:ch amount=@ud]
  ==
--

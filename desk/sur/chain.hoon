|%
++  addr  @ux
++  txn-signed
  $:  signature=@ux
      txn-unsigned
  ==
++  txn-unsigned
  $:  who=addr
      nonce=@ud
      txn-stub
  ==
++  txn-stub
  $:  app=@tas
      ::  fees are ignored for now
      fee=@ud
      cmd=*
  ==
++  wallet
  $:  pub=@ux
      sec=@ux
  ==
++  wallets  (map cord wallet)
--

|%
::  blockchain defs
+$  chain  (list block)
+$  block  [hash=@uvH stone]  ::  [(shax (jam stone)) stone]
::  stone: unhashed block
+$  stone
  $:  hght=@ud             ::  block height
      prev=@uvH            ::  parent block hash of (previous) txns
      stmp=@da             ::  timestamp (deterministic in case of slash)
      txns=(list txn)      ::  block size is arbitrary
      mint=@p              ::  minter address
      slsh=?               ::  whether this is a slash block
      ::  slash block must have empty txns
  ==   
::  germ: proto-transaction (user-entered values)
+$  germ
  $:  src=@p
      bid=@udtoken
      act=chain-action
  ==
+$  chain-action
  $%  [%put des=@p amt=@udtoken bid=@udtoken]
      %bet
      %lay
  ==
::  base transaction
+$  txn
  $:  tim=@da
      tid=@ud
      germ
  ==
::  blacklist duration
++  decay-rate  `@dr`~d7
::  scale factor for tokens  XX revisit this
++  token-scale  `@ud`(pow 2 32)
::
+$  shared-state
  $:  ledger=(map @p @udtoken)
      validators=(list @p)      ::  round-robin of validator addresses
      blacklist=(map @p @da)
  ==
::
::  seed: attestation of a pending txn
+$  seed  [src=@p tid=@ud hax=@uvH]
::
::  agent actions
++  axn
  $%  
    [%sire =germ]  :: produce a local txn
    [%cast =seed]  :: receive a remote txn  
    [%born ~]  :: mint genesis block
  ==
--

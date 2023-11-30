|%
::  blockchain defs
+$  chain  (list block)
+$  block
  $:  hght=@ud             ::  block height
      prev=@uvH            ::  parent block hash of (previous) txns
      hash=@uvH            ::  block hash of (current) txns
      stmp=@da             ::  timestamp (deterministic in case of slash)
      txns=(list txn)      ::  block size is arbitrary
      mint=@p              ::  minter address
      slsh=?               ::  whether this is a slash block
      ::  slash block must have empty txns
  ==
::  proto transaction
+$  germ
  $:  src=@p
      met=metadata
  ==
+$  metadata
  $%  [%put des=@p amt=@udtoken bid=@udtoken]
      [%bet bid=@udtoken]
      [%lay bid=@udtoken]
  ==
::  base transaction
+$  txn
  $:  src=@p
      tid=@ud
      met=metadata
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
+$  seed  [src=@p tid=@ud hax=@uvH]
++  axn
  $%  [%sire =germ]  :: produce a local txn
      [%cast =seed]  :: receive a remote txn
  ==
--

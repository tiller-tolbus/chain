/+  *mip
|%
+$  signature  [p=@uvH q=ship r=life]
+$  action
  $%  [%start ts=@da]
      [%broadcast [vote quorum]]
      [%txn =txn]
      [%faucet =addr]
      :: [%vote s=signature vote]
  ==
+$  voted-bloc  [vote =quorum]
+$  history  ((mop @ud voted-bloc) lth)
++  hon      ((on @ud voted-bloc) lth)
+$  bloc-update
  $%  [%blocs =history]
      [%reset =reset-id]
  ==
+$  reset-id  @
::  named to avoid conflict with stdlib block
+$  bloc
  $:  mint=node
      txns=(list txn)
      ts=@da
      ::  last=quorum
  ==
::  address to nonce to transaction
+$  mempool  (mip addr @ud txn)
::  for the testnet, transactions are not validated
::  and %ledger will ignore invalid ones
+$  txn
  $:  signature=@ux
      txn-unsigned
  ==
+$  txn-unsigned
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
:: +$  signed-bloc  (pair signature bloc)
:: +$  node  $|  @p  |=(p=@p (lte p ~fipfes))
+$  node  @p
+$  height  @ud
+$  round  @ud
:: +$  step  $?
::     %new-height
::     %propose
::     %prevote
::     %precommit
::     %commit
::   ==
::  named to avoid conflict with stdlib step
+$  steppe  $~(%1 $?(%1 %2 %3 %4))  :: stage of the app, see above
+$  stage  $?(%2 %1)  :: voting stage
++  delta  ~s4  :: time between steps
++  addendum-delta  ~s2
+$  referendum  [=height =round =stage]
+$  vote
  $:  =bloc
      referendum
  ==
:: +$  raw-signed-vote  @
:: +$  signed-vote  [signature=@ =node =vote]  
:: ::  signatures are a jam of [signed-msg msg]
:: +$  signed-vote  signature
+$  quorum  (set signature)
+$  qc  (unit [vote =quorum])  :: should only be non-null when valid
+$  vote-store  (jug vote signature)
::  constants
:: ++  nodes  ^-  (lest node)
::   :~  ~woldeg
::       ~sartyr
::       ~mocbel
::       ~posdeg
::       ~firdun
::       ~tomdys
::       ~siddef
::       ~sibnus
::       ~holnes
::       ~livpub
::       ~micdyt
::       ~wanlur
::       ~davbel
::       ~hosdys
::       ~ridlyd
::       ~sabbus
::       ~firbex
::       ~fipdel
::       ~matwet
::       ~matdel
::       ~bilreg
::       ~racwet
::       ~roswet
::       ~batbex
::       ~fodwet
::       ~wittyv
::       ~mosdef
::       ~matfen
::       ~hobdem
::       ~pocwet
::   ==
:: ++  primary  ~woldeg
:: fake constants
++  nodes  ^-  (lest node)
  ~[~zod ~nec ~bud ~wes]
++  primary  ~zod
::
+$  addr  @ux
::  functions
:: ++  quorum
::   |%
::   ++  shape
::     |=  =qc
::     ^-  ?
::     ?~  qc  .n
::     =/  one  n.qc
::     %+  ~(all by qc)
::     |=  [=node =vote]
::     ^-  ?  =(one vote)
::   --
--

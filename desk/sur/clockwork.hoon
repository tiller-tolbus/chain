/+  *mip
|%
+$  signature  [p=@uvH q=ship r=life]
+$  action
  $%  [%start ts=@da]
      [%broadcast =qc]
      [%txn =txn]
      [%faucet =addr]
      :: [%vote s=signature vote]
  ==
+$  voted-bloc
  $:  =bloc
      =quorum
  ==
+$  history  ((mop @ud voted-bloc) lth)
++  hon  ((on @ud voted-bloc) lth)
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
      =height
      =round
      last=quorum
  ==
::  address to nonce to transaction
+$  mempool  (mip @ux @ud txn)
::  for the testnet, transactions are not validated
::  and %ledger will ignore invalid ones
+$  txn  ^
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
++  delta  ~s3  :: time between steps
++  addendum-delta  ~s2
+$  referendum  [=height =round =stage]
+$  vote
  $:  =bloc
      referendum
  ==
:: +$  raw-signed-vote  @
:: +$  signed-vote  [signature=@ =node =vote]  ::  signatures are a jam of [signed-msg msg] so we can cue the vote out of it
:: +$  signed-vote  signature
+$  quorum  (set signature)
+$  qc  [vote =quorum]  :: provisional qc, no guarantees of majority
+$  vote-store  (jug vote signature)
::  constants
++  nodes  ^-  (lest node)
:~  ~zod
    ~nec
    ~bud
    ~wes
==
++  primary  ~zod
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

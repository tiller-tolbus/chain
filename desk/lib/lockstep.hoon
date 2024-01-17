:: types
|%
+$  bootstrap  [%bootstrap ts=@da]
+$  action
  $%  [%broadcast =qc]
      [%vote vote]  :: eventually we get gossip votes so this should be annotated with voter+signature
  ==

+$  history  (list block)
+$  block  [noun=* mint=node ts=@da]  :: Mint should include a signature to be validated
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
+$  step  $?(%1 %2 %3 %4)  :: stage of the app, see above
+$  stage  $?(%1 %2)  :: voting stage
++  delta  ~s5  :: time between steps
+$  referendum  [=height =round =stage]
+$  vote
  $:  =block
      referendum
  ==
:: +$  raw-signed-vote  @
:: +$  signed-vote  [signature=@ =node =vote]  ::  signatures are a jam of [signed-msg msg] so we can cue the vote out of it
+$  signed-vote  @p  ::  provisional
+$  quorum  (set signed-vote)
+$  qc  [vote quorum]
+$  vote-store  (map vote quorum)
::  constants
++  nodes  ^-  (list node)
:~  ~zod
    ~nec
    ~bud
    ~wes
==
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

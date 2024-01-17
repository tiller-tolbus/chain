:: types
|%
+$  signature  [p=@uvH q=ship r=life]
+$  action
  $%  [%start ts=@da]
      [%broadcast =qc]
      [%vote s=signature vote]  :: eventually we get gossip votes so this should be annotated with voter+signature
  ==

+$  history  (list (pair signed-block qc))
+$  block    [noun=* ts=@da =height]  :: Mint should include a signature to be validated
+$  signed-block  (pair signature block)
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
+$  step  $~(%1 $?(%1 %2 %3 %4))  :: stage of the app, see above
+$  stage  $?(%2 %1)  :: voting stage
++  delta  ~s5  :: time between steps
+$  referendum  [=height =round =stage]
+$  vote
  $:  block=signed-block
      referendum
  ==
:: +$  raw-signed-vote  @
:: +$  signed-vote  [signature=@ =node =vote]  ::  signatures are a jam of [signed-msg msg] so we can cue the vote out of it
+$  signed-vote  signature
+$  quorum  (set signed-vote)
+$  qc  [vote quorum]  :: provisional qc, no guarantees of majority
+$  vote-store  (map vote quorum)
::  constants
++  nodes  ^-  (list node)
:~  ~zod
    ~nec
    ~bud
    ~wes
    :: ~rus
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

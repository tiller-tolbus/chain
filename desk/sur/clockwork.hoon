:: types
|%
+$  signature  [p=@uvH q=ship r=life]
+$  action
  $%  [%start ts=@da]
      [%broadcast =qc]
      :: [%vote s=signature vote]
  ==
+$  history  (list block)
+$  block
  $:  mint=node
      noun=*
      ts=@da
      =height
      last=quorum
  ==
:: +$  signed-block  (pair signature block)
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
++  delta  ~s3  :: time between steps
+$  referendum  [=height =round =stage]
+$  vote
  $:  =block
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

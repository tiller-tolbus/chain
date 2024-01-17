:: types
|%
+$  node  $|  @p  |=(p=@p (lte p ~fipfes))
+$  height  @ud
+$  round  @ud
+$  step  $?  
    %new-height
    %propose
    %prevote
    %precommit
    %commit
  ==
+$  position  [height round step]
+$  vote
  $:
    block=*
    =height
    =round
    step=?(%prevote %precommit)
  ==
+$  qc  (map node vote)
--
::  functions
|%
++  quorum
  |%
  ++  shape
    |=  =qc
    ^-  ?
    =+  n.qc
    %+  ~(all in qc)
    |=  =vote
    ^-  ?
    ?&  
        =(block.n block.vote)
        =(height.n height.vote)
        =(round.n round.vote)
        =(step.n step.vote)
    ==
  --
-- 
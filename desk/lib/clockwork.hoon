/-  *clockwork
|%
::  sm: supermajority
++  sm
  |=  a=@ud
  ^-  @ud
  +(-:(dvr (mul a 2) 3))
::
::  vs: vote-store utilities
++  vs
  |_  =vote-store
  ++  latest-by
    |=  leader=node
    :: ~&  vote-store
    ^-  (unit qc)
    %+  roll  ~(tap by vote-store)
    |=  [i=qc acc=(unit qc)]
    ::  ~&  "checking mint"
    ?.  =(mint.block.i leader)  acc
    :: ~&  "checking height"
    ~&  [our-height=height their-height=height.i]
    ::  ?.  =(height height.i)  acc
    :: ~&  "checking acc"
    ?~  acc  (some i)
    :: ~&  "checking recency"
    ?:  (more-recent:qcs i u.acc)  (some i)  acc
  ::
  ++  future-blocks
    |=  =height
    ^-  (list qc)
    %+  sort
    %+  skim  ~(tap by vote-store)
    |=  i=qc  ^-  ?
    ?&  %+  gte  ~(wyt in +.i)  (sm (lent nodes))
        (gte height.i height)
        .=(%2 stage.i)
    ==
    |=  [a=qc b=qc]  (gth height.a height.b)
  --
::  qcs: qc utilities
++  qcs
  |%
  ++  as-recent
    |=  [a=qc b=qc]  
    ^-  ?
    ?:  (gte round.a round.b)  %.y
    ?&  .=(round.a round.b)
        (gte stage.a stage.b)
    ==
  ++  more-recent
    |=  [a=qc b=qc]
    ^-  ?
    ?:  (gth round.a round.b)  %.y
    ?&  .=(round.a round.b)
        (gth stage.a stage.b)
    ==
  --
--
  
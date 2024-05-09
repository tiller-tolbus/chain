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
  ++  valid-qcs
    |=  ref=referendum
    ^-  (list qc)  ::  there should only be one but w/e
    ~&  checking-qcs=[stage.ref round.ref height.ref]
    %+  skim  ~(tap by vote-store)
    |=  i=qc  ^-  ?
    :: ~&  >  qc=[stage.i round.i height.i ~(wyt in +.i)]
    ?&  %+  gte  ~(wyt in quorum.i)  (sm (lent nodes))
        .=(height.ref height.i)
        .=(round.ref round.i)
        .=(stage.ref stage.i)
    ==
  :: ++  majority-qcs
  ::   |=  nodes=(list node)
  ::   %+  skim  ~(tap by vote-store)
  ::   |=  i=qc  ^-  ?
  ::   %+  gte  ~(wyt in +.i)  (sm (lent nodes))
  ++  most-recent
    |=  =height
    %+  roll  ~(tap by vote-store)
    |=  [i=qc acc=(unit qc)]
    ?.  (valid:qcu i)  acc
    ?.  =(height height.i)  acc
    ?~  acc  (some i)
    ?:  (more-recent:qcu i u.acc)  (some i)  acc
  ++  latest-by
    |=  leader=node
    :: ~&  vote-store
    ^-  (unit qc)
    %+  roll  ~(tap by vote-store)
    |=  [i=qc acc=(unit qc)]
    ::  ~&  "checking mint"
    ?.  =(mint.bloc.i leader)  acc
    :: ~&  "checking height"
    :: ~&  [our-height=height their-height=height.i]
    ::  ?.  =(height height.i)  acc
    :: ~&  "checking acc"
    ?~  acc  (some i)
    :: ~&  "checking recency"
    ?:  (more-recent:qcu i u.acc)  (some i)  acc
  ::
  ++  future-blocs
    |=  =height
    ^-  (list qc)
    %+  sort
    %+  skim  ~(tap by vote-store)
    |=  i=qc  ^-  ?
    ?&  %+  gte  ~(wyt in quorum.i)  (sm (lent nodes))
        (gte height.i height)
        .=(%2 stage.i)
    ==
    |=  [a=qc b=qc]  (lth height.a height.b)
  --
::  qcu: qc utilities
++  qcu
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
  ++  valid
    |=  =qc  ^-  ?
    %+  gte  ~(wyt in quorum.qc)  (sm (lent nodes))
  --
--

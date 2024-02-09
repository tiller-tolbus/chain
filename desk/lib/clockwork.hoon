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
    ::  Have we received something from the leader this round,
    ::  and is that at least as recent as what we have locally?
    %+  roll  ~(tap by vote-store)
    |=  [i=qc acc=(unit qc)]
    ::  Check minting node.
    :: ?.  =(mint.block.i leader)  acc
    ?~  acc  (some i)
    ::  Given a leader and a vote-store, what is the latest
    ::  vote we have from that leader?
    ?:  ?&  (more-recent:qcu i u.acc)
            ::  Does +.i contain a sig from the leader?
            (~(any in quorum.i) |=(=signature =(r.signature leader)))
        ==
    (some i)  acc
  ::
  ++  future-blocks
    |=  =height
    ^-  (list qc)
    %+  sort
    %+  skim  ~(tap by vote-store)
    |=  i=qc  ^-  ?
    ?&  %+  gte  ~(wyt in quorum.i)  (sm (lent nodes))
        (gte height.i height)
        .=(%2 stage.i)
    ==
    |=  [a=qc b=qc]  (gth height.a height.b)
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
  
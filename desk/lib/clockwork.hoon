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
  ++  votes-at
    |=  =height
    ^+  vote-store
    %-  ~(gas by *_vote-store)
    %+  skim
    ~(tap by vote-store)
    |=  [=vote =quorum]
    =(height height.vote)
  ++  most-recent
    |=  =height
    ^-  (unit qc)
    %+  roll  ~(tap by vote-store)
    |=  [i=qc acc=(unit qc)]
    ?.  =(height height.i)  acc
    ?.  (valid:qcu i)  acc
    ?~  acc  (some i)
    ?:  (more-recent:qcu i u.acc)  (some i)  acc
  ++  latest-by
    |=  [leader=node =height]
    :: ~&  vote-store
    ^-  (unit qc)
    %+  roll  ~(tap by (votes-at height))
    |=  [i=qc acc=(unit qc)]
    ::  ~&  "lbl: checking vote store"
    ?~  (skim ~(tap in quorum.i) |=(sig=signature =(q.sig leader)))
      acc
    :: ~&  "lbl: checking acc"
    ?~  acc  (some i)
    :: ~&  "lbl: checking recency"
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
    ::  ~?  !=(height.a height.b)  "as-recent: heights unequal"
    ?:  (gte round.a round.b)  %.y
    ?&  .=(round.a round.b)
        (gte stage.a stage.b)
    ==
  ++  more-recent
    |=  [a=qc b=qc]
    ^-  ?
    ::  ~?  !=(height.a height.b)  "more-recent: heights unequal"
    ?:  (gth round.a round.b)  %.y
    ?&  .=(round.a round.b)
        (gth stage.a stage.b)
    ==
  ++  valid
    |=  =qc  ^-  ?
    %+  gte  ~(wyt in quorum.qc)  (sm (lent nodes))  
  --
::  mempool
++  mem
  |_  =mempool
  ++  pick
    ^-  (list txn)
    ::  number of transactions in a bloc
    =/  needed  1.024
    =/  count  0
    =/  txns=(list txn)  ~
    |-
    ?~  mempool  txns
    ?:  =(count needed)  txns
    =/  addr=@ux
      =/  addrs  ~(key by `^mempool`mempool)
      ?~  addrs  !!
      -:~(get to addrs)
    =/  nonces
      %+  scag 
        (sub needed count) 
      (sort ~(tap in (~(key bi `^mempool`mempool) addr)) lth)
    =/  new-txns=(list txn)
      %+  turn  nonces
      |=  nonce=@ud
      (~(got bi `^mempool`mempool) addr nonce)
    %=  $
      count    (add count (lent nonces))
      txns     `(list txn)`(weld new-txns txns)
      mempool  (~(del by `^mempool`mempool) addr)
    ==
  ++  trim
    |=  txns=(list txn)
    ^+  mempool
    ?~  txns  mempool
    =/  shape  ,[who=@ux nonce=@ud @ @ @ *]
    ?.  ?=(shape i.txns)  $(txns t.txns)
    $(mempool (~(del bi mempool) who.i.txns nonce.i.txns), txns t.txns)
  --
--

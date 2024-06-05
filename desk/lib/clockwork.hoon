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
  ++  prune
    |=  =height
    ^+  vote-store
    %-  ~(gas by *^vote-store)
    %+  skip  ~(tap by vote-store)
    |=  [=vote quorum]
    (lte height.vote height)
  ++  valid-qcs
    |=  ref=referendum
    ^-  (list qc)  ::  there should only be one but w/e
    ~&  checking-qcs=[stage.ref round.ref height.ref]
    %-  turn  :_  some
    ^-  (list [vote quorum])
    %+  skim  ~(tap by vote-store)
    |=  i=[vote =quorum]  ^-  ?
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
    |=  =round
    ^+  vote-store
    %-  silt  %+  skim
    ~(tap by vote-store)
    |=  [=vote =quorum]
    =(round round.vote)
  ++  most-recent
    |=  =height
    ^-  qc
    %+  roll  ~(tap by vote-store)
    |=  [i=[vote =quorum] acc=qc]
    ?.  =(height height.i)  acc
    =/  =qc  (certify:qcu i)
    ?:((more-recent:qcu qc acc) qc acc)
  ++  latest-by
    |=  [leader=node =round]
    :: ~&  vote-store
    ^-  (set [vote quorum])
    ::  we would like to know if the leader voted this round
    %-  silt
    %+  skim
      ~(tap by (votes-at round))
    |=  [vote =quorum]
    %-  ~(any in quorum)
    |=  sig=signature
    =(q.sig leader)
    ::
    :: %+  roll  ~(tap by (votes-at height))
    :: |=  [i=[vote =quorum] acc=(unit [vote quorum])]
    :: ::  ~&  "lbl: checking vote store"
    :: ?~  (skim ~(tap in quorum.i) |=(sig=signature =(q.sig leader)))
    ::   acc
    :: :: ~&  "lbl: checking acc"
    :: ?~  acc  (some i)
    :: :: ~&  "lbl: checking recency"
    :: ?:  (more-recent:qcu i u.acc)  (some i)  acc
  ::
  ++  future-blocs
    |=  =height
    ^-  (list [vote quorum])
    %-  sort  :_
      |=  [a=[vote quorum] b=[vote quorum]]
      (lth height.a height.b)
    %-  murn  :_  certify:qcu
    %+  skim  ~(tap by vote-store)
    |=  i=[vote =quorum]  ^-  ?
    ?&  %+  gte  ~(wyt in quorum.i)  (sm (lent nodes))
        (gte height.i height)
        .=(%2 stage.i)
    ==
  --
::  qcu: qc utilities
++  qcu
  |%
  ++  as-recent
    |=  [a=qc b=qc]
    ^-  ?
    ::  ~?  !=(height.a height.b)  "as-recent: heights unequal"
    ?~  a  !(valid b)
    ?~  b  (valid a)
    ?:  (gte round.u.a round.u.b)  %.y
    ?&  .=(round.u.a round.u.b)
        (gte stage.u.a stage.u.b)
    ==
  ++  more-recent
    |=  [a=qc b=qc]
    ^-  ?
    ::  ~?  !=(height.a height.b)  "more-recent: heights unequal"
    ?~  a  %.n
    ?~  b  (valid a)
    ?:  (gth round.u.a round.u.b)  %.y
    ?&  .=(round.u.a round.u.b)
        (gth stage.u.a stage.u.b)
    ==
  ++  valid
    |=  =qc  ^-  ?
    ?~  qc  %.n
    (gte ~(wyt in quorum.u.qc) (sm (lent nodes)))
  ++  certify
    ::  returns a qc if i is valid
    ::  null otherwise
    |=  i=[vote =quorum]
    ^-  qc
    ?.  (valid (some i))
      ~
    (some i)
  --
::  mempool
++  mem
  |_  =mempool
  ++  pick
    ^-  (list txn)
    ::=/  memstream=(list txn)  
    :: ::  todo: sort by fee
    :: %+  turn  ~(tap bi mempool)
    :: |=  [* * =txn]  txn
    ::=|  txns=(list txn)
    ::::  if mempool is smaller than max, return entire mempool
    ::?:  (gth max-bloc (met 3 (jam memstream)))  txns
    ::::  otherwise, loop
    ::|-
    ::::  if nothing left, finish
    ::?~  memstream  txns
    ::::  if over limit, revert to last
    ::?:  (gth (met 3 (jam txns)) max-bloc)  
    ::  ?~(txns !! t.txns)  :: it won't crash because it's big
    ::::  else, process one tx
    ::=/  =txn  i.memstream
    ::%=  $
    ::  txns  :-(txn txns)
    ::  memstream  t.memstream
    ::==
    ::  number of transactions in a bloc
    =|  txns=(list txn)
    =/  needed  (bex 4)
    =/  count  0
    |-
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
    $(mempool (~(del bi mempool) who.i.txns nonce.i.txns), txns t.txns)
  --
--

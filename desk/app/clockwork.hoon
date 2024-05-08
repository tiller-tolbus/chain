/-  *clockwork, pki=pki-store, ch=chain
/+  lib=clockwork,
    dbug,
    *mip
=,  crypto
|%
+$  versioned-state
$%  state-0
==
+$  state-0
$:  %0
    $=  local          :: local variables from spec
      $:
        =height
        =bloc
        qc=(unit qc)   ::  quorum certificate
        =mempool
      ==
                       ::  global state, this should sync among nodes
    robin=(lest node)  ::  node order, round-robin
    =history
    =vote-store
    ::  keys
    our-life=@ud
    keys=acru:ames
    =pki-store:pki
    faucet-nonce=@ud
==
+$  card  card:agent:gall
--
%-  agent:dbug
=|  state-0
=*  state  -
^-  agent:gall
=<
|_  =bowl:gall
+*  this      .
    hd  ~(. +> bowl)
::
++  on-init
  ~&  >  "%chain initialized"
  :_  this(robin nodes)
    :-  clockstep-watch-card:hd
    :-  fake-pki-card:hd  pki-cards:hd
::
++  on-leave
  |=  =path
  [~ this]
++  on-fail
  |=  [=term =tang]
  %-  (slog leaf+"error in {<dap.bowl>}" >term< tang)
  [~ this]
++  on-save   !>(state)
++  on-load
  |=  old-state=vase
    ::  dev
    ::  :_  this(robin nodes)
    ::    :-  clockstep-watch-card:hd
    ::    :-  fake-pki-card:hd  pki-cards:hd
    ::  prod
    :-  ~  this(state !<(state-0 old-state))
::
++  on-watch
  |=  =(pole knot)
  ?+  pole  ~|(bad-watch-path+`path`pole !!)
      [%blocs ~]
    :_  this
    ~[[%give %fact ~ bloc-update+!>([%blocs history])]]
  ==
++  on-poke
  |=  [=mark =vase]
  |^
  :: check various conditions for testing
  ?.  ?=(%noun mark)  [~ this]
    ?:  ?=(%keys q.vase)
      ~&  `signature`[(sigh:as:keys 1) our.bowl our-life]
      [~ this]
    ?:  ?=(%reset q.vase)   :_  this  nuke-cards:hd
    ?:  ?=(%sprint q.vase)  :_  this  dbug-cards:hd
    ?:  ?=(%print q.vase)
      =/  his  (bap:hon history)
      ?~  his  ~&  >>>  "no blocs found"  [~ this]
      ~&  >>  last-bloc=i.his  [~ this]
    ?:  ?=(%nuke q.vase)
      ~&  >>>  "nuking state"
      ~&  >>  history=history
      ?>  =(src.bowl primary)
      =.  state  *state-0
      :_  this(robin nodes)  [stop-card:hd fake-pki-card:hd pki-cards:hd]
    ::  TODO pause poke?
    ::  actual checks
    ::  throw away unrecognized pokes
    =/  uaction  ((soft action) q.vase)
    ?~  uaction  [~ this]
    =/  action  u.uaction
    ?-  -.action
      %start      (handle-start +.action)
      %broadcast  (handle-broadcast +.action)
      %txn        (handle-txn +.action)
      %faucet     (handle-faucet +.action)
    ==
  ++  handle-start
    |=  ts=@da
    ~&  handling-start=ts
    ?.  =(*bloc bloc.local)  [~ this]
    ~&  "bootstrapping"
    =/  init-bloc=bloc   [our.bowl ~ ts height.local 0 ~]
    =.  bloc.local  init-bloc
    =.  qc.local  ~
    ?.  .=(src.bowl i.robin)  [~ this]
    :_  this
    :-  (start-timer-card:hd ts)
        (bootstrap-cards:hd ts)
  ++  handle-broadcast
    |=  =qc  ^-  (quip card _this)
    ~&  handling-broadcast=[from=src.bowl h=height.qc r=round.qc s=stage.qc]
    ?:  (lth height.qc height.local)
      ~&  bail-height-below-current=[src=height.qc our=height.local]
      [~ this]
    =/  =vote  -.qc
    =/  sigs=(list signature)  ~(tap in quorum.qc)
    |-
    ?~  sigs  [~ this]
    =/  sig  i.sigs
    =/  pass  (~(get bi pki-store) q.sig r.sig)
    ?~  pass  $(sigs t.sigs)
    =/  msg  (jam vote)
    =/  keys  (com:nu:crub u.pass)
    ?.  (safe:as:keys p.sig msg)
      $(sigs t.sigs)
    $(sigs t.sigs, vote-store (~(put ju vote-store) vote sig))
  ++  handle-txn
    |=  =txn
    ?>  (gte (bex 10) (met 3 (jam txn)))
    ?.  ?=(txn-signed:ch txn)  [~ this]
    [~ this(mempool.local (~(put bi mempool.local) who.txn nonce.txn txn))]
  ++  handle-faucet
    |=  =addr
    =/  txn-unsigned
      :*  (latest-key our.bowl)
          faucet-nonce
          %ledger
          0
          [%send addr (bex 16)]
      ==
    ~&  >>  txn-unsigned
    ~&  >>  [(sigh:as:keys (jam txn-unsigned)) txn-unsigned]
    =.  faucet-nonce  +(faucet-nonce)
    (handle-txn [(sigh:as:keys (jam txn-unsigned)) txn-unsigned])
  --
++  on-peek   |=(=(pole knot) ~)
++  on-agent
  |=  [=(pole knot) =sign:agent:gall]
  |^
  ::  ~>  %bout.[0 '%clockwork +on-agent']
  ?+  pole  [~ this]
      [%tick ~]
    ?:  ?=(%kick -.sign)  :_  this  :~(clockstep-watch-card:hd)
    ?.  ?=(%fact -.sign)  [~ this]  (handle-tick (@ud q.q.cage.sign))
      [%pki-store ~]
    ?+  -.sign  [~ this]
        %kick  :_  this  :~(pki-watch-card:hd)
        %fact
      ?+  p.cage.sign  ~&([%bad-mark p.cage.sign] [~ this])
          %pki-snapshot
        ~&  >>  "pki-snapshot-received"
        =/  new-pki-store  !<(pki-store:pki q.cage.sign)
        [~ this(pki-store new-pki-store)]
          %pki-diff
        =/  entry  !<(pki-entry:pki q.cage.sign)
        =+  entry
        =/  new-pki-store  (~(put bi pki-store) ship life pass)
        [~ this(pki-store new-pki-store)]
      ==
    ==
  ==
  ::  Main agent logic
  ++  handle-tick
    |=  count=@ud  ^-  (quip card _this)
    =/  [=round rem=@]
      ::  ?:  =(count 0)
      ::    [0 0]
      (dvr (dec count) 4)
    =/  =steppe  (steppe +(rem))
    =/  leader=node  (snag (mod round (lent robin)) `(list node)`robin)
    ~&  >>>  timer-pinged-at=[count=count height=height.local round=round steppe=steppe]
    ~&  >  current-time=[m s f]:(yell now.bowl)
    ~&  >>  nexttimer-at=[m s f]:(yell (add now.bowl ~s3))  ::  uhm
    ?-  steppe
        %1
      ~&  >>  leader=leader
      ::  In step 1 only the leader votes
      ?.  .=(our.bowl leader)  bail
      ::  If we are the leader we look for a qc in our vote store at the current height
      ::  that is more recent (i.e. same height, higher round OR stage)
      ::  than our local state qc. If we find one, we vote for that and update our local
      ::  bloc and state.
      ::  If not, we propose our current local bloc with txns from our mempool
      =/  most-recent  (~(most-recent vs:lib vote-store) height.local)
      ~&  most-recent=most-recent
      =.  state
        ?~  most-recent
          %=  state
            txns.bloc.local  (pick-txns-from mempool.local)
            round.bloc.local  round
          ==
        %=  state
          bloc.local  bloc.u.most-recent
          qc.local     (some u.most-recent)
        ==
      :: :_  increment-step
      :_  this
      %-  broadcast-cards:hd
      =/  =vote  [bloc.local height.local round %1]
      :: ~&  >  leader-vote=[bloc.local height=height.local round=round]
      =/  sig=(set signature)  (silt ~[[(sigh:as:keys (jam vote)) our.bowl our-life]])
      [vote sig]
        ::
        %2
      ::  In step 2 all nodes come to vote.
      ::  Nodes look for the latest vote by the leader (i.e. what happened on step 1)
      =/  lbl=(unit qc)  (~(latest-by vs:lib vote-store) leader)
      ::  If the leader didn't vote on step 1 (which really shouldn't happen!) we bail
      ::  bail meaning incrementing the step and doing nothing
      ?~  lbl  ~&  "no recent vote from leader found"  bail
      ::  We compare the bloc sent by the leader with our local bloc
      ::  If the leader's bloc is not at all more recent (in height and (round or stage))
      ::  we bail as nothing new was received
      ?.  =(height.u.lbl height.local)
        ~&  "received bloc at incorrect height"
        bail
      =/  received-new=?
        ?~  qc.local  %.y
        (as-recent:qcu:lib u.lbl u.qc.local)
      ~&  >  received-new=received-new
      ?.  received-new
        ~&  "did not receive new bloc from leader"
        bail
      ::  If we correctly received a new bloc from the leader we save that to local state
      ::  and vote for it
      =.  state
      %=  state
        bloc.local  bloc.u.lbl
        qc.local     lbl
      ==
      :_  this
      =/  =vote  [bloc.u.lbl height.u.lbl round %1]
      ~&  >>  voting=[height.local round %1]
      (vote-and-broadcast u.lbl vote)
        ::
        %3
      ::  In step 2 we should have received votes from 2/3 of the nodes for some bloc
      ::  in the current height and round, and stage %1. We check for that.
      =/  valid  (~(valid-qcs vs:lib vote-store) height.local round %1)
      ::  If that's not the case we bail
      ?~  valid  ~&  "no valid qcs at stage 1"  bail
      ::  If good we update our state, and send a stage %2 (final vote).
      =.  state
      %=  state
        bloc.local  bloc.i.valid
        qc.local     (some i.valid)
      ==
      :_  this
      =/  vote  [bloc.i.valid height.local round %2]
      ~&  >>  voting=[height.local round %2]
      (vote-and-broadcast i.valid vote)
        %4
      ::  Same as above, we should have received 2/3 of stage %2 votes for something
      =/  valid  (~(valid-qcs vs:lib vote-store) height.local round %2)
      ::  If we didn't find a valid quorum we increment the step
      ::  and schedule the final addendum cleanup stage
      ?~  valid  ~&  "no valid qcs at stage 2"  schedule-addendum
      ::  If all good we commit the bloc to history, reset local bloc and qc,
      ::  increment height
      ::  then broadcast the qc of the committed bloc to sync everyone's vote store
      =/  init-bloc  [our.bowl ~ now.bowl +(height.local) round ~]
      =.  state
      %=  state
        history
          ~&  >  ~
          ~&  >  bloc-commited=[h=height.bloc.i.valid r=round.bloc.i.valid who=mint.bloc.i.valid txns=txns.bloc.i.valid]
          ~&  >  ~
        %^  put:hon  history
          height.bloc.i.valid
        `voted-bloc`[bloc.i.valid quorum.i.valid]
        mempool.local  (trim-mempool mempool.local txns.bloc.i.valid)
        height.local  +(height.local)
        bloc.local  init-bloc
        qc.local     ~
      ==
      :: :_  increment-step
      :_  this
      :*  addendum-card:hd
          bloc-fact-card:hd
          (broadcast-cards:hd i.valid)
      ==
    ==
++  vote-and-broadcast
  |=  [p=qc =vote]  ^-  (list card)
  =/  =signature  [(sigh:as:keys (jam vote)) our.bowl our-life]
  %+  roll  `(list @p)`nodes  |=  [i=@p acc=(list card)]
  %+  weld  acc
  :~  (broadcast-card p i)
      (vote-card signature vote i)
  ==
  ++  schedule-addendum
    :_  this
    :~  addendum-card:hd
    ==
  ++  bail
    ~&  "bail"
    [~ this]
  --
++  on-arvo
  |=  [=(pole knot) =sign-arvo]
  ^-  (quip card _this)
  |^
  ?:  ?=(%jael -.sign-arvo)  (update-keys +.sign-arvo)
  ?.  ?=(%behn -.sign-arvo)  [~ this]
    ?.  ?=([%addendum ~] pole)  [~ this]  handle-addendum
  ::  %jael
  ++  update-keys
    |=  g=gift:jael
    :: ~&  updating-keys=g
    ^-  (quip card _this)
    ?.  ?=(%private-keys -.g)  [~ this]
    =/  vein  vein.g
    =/  private-key  (~(get by vein) life.g)
    ?~  private-key  ~&  >>>  "private key not found"  [~ this]
    :-  ~
    %=  this
      our-life  life.g
      keys      (nol:nu:crub u.private-key)
    ==
  ::  %final stage of bloc syncing
  ++  handle-addendum
    ~&  >>  addendum-phase=[m s f]:(yell now.bowl)
    ^-  (quip card _this)
    ::  In the addendum stage we look in our vote store for valid qcs of stage %2 of a height
    ::  greater than our local height
    =/  valid  (~(future-blocs vs:lib vote-store) height.local)
    ::  We then iterate through them and do what we did in step %4; commit bloc to history,
    ::  increment height, reset our local bloc/qc and broadcast the committed bloc
    =|  new-cards=(list card)
    |-
    ?~  valid  [new-cards this]
    =/  init-bloc  [our.bowl ~ now.bowl +(height.local) 0 ~]
    %=  $
      history
        ~&  >  ~
        ~&  >  bloc-commited=[h=height.bloc.i.valid r=round.bloc.i.valid who=mint.bloc.i.valid txns=txns.bloc.i.valid]
        ~&  >  ~
        %^  put:hon  history
          height.bloc.i.valid
        [bloc.i.valid quorum.i.valid]
      height.local   +(height.local)
      ::  bloc.local    init-bloc
      qc.local       ~
      mempool.local  (trim-mempool mempool.local txns.bloc.i.valid)
      new-cards  (weld new-cards (broadcast-cards:hd i.valid))
      valid  t.valid
    ==
  :: ++  increment-round
  ::   %=  this
  ::     round  +(round)
  ::     robin  shuffle-robin
  ::     step  %1
  ::   ==
  :: ++  shuffle-robin  ^+  robin
  ::   :: argh hoon list types
  ::   =/  shuffled  (snoc t.robin i.robin)
  ::   ?~  shuffled  robin  shuffled
  --
--
|_  =bowl:gall
::::  cards
::  clockstep
++  clockstep-watch-card
  [%pass /tick %agent [our.bowl %clockstep] %watch /tick]
++  start-timer-card
  |=  ts=@da
  [%pass /wire %agent [our.bowl %clockstep] %poke [%noun !>([%start ts])]]
::  pki
++  pki-cards
  ^-  (list card)
  :~  [%pass /private-keys %arvo %j %private-keys ~]
      pki-watch-card
  ==
++  pki-watch-card
  ::  subscribe to pki-store updates
  [%pass /pki-store %agent [our.bowl %pki-store] %watch /pki-diffs]
++  broadcast-cards
  |=  p=qc  ^-  (list card)
  %+  turn  nodes  |=  s=@p  (broadcast-card p s)
++  broadcast-card
  |=  [p=qc sip=ship]  ^-  card
  [%pass /wire %agent [sip %clockwork] %poke [%noun !>([%broadcast p])]]
++  vote-card
  |=  [s=signature =vote sip=@p]
  =/  p  [vote (silt ~[s])]
  [%pass /wire %agent [sip %clockwork] %poke [%noun !>([%broadcast p])]]
::
++  bootstrap-cards
  |=  ts=@da
  %+  turn  nodes  |=  sip=@p
  [%pass /wire %agent [sip %clockwork] %poke [%noun !>([%start ts])]]
++  dbug-cards
  %+  turn  nodes  |=  sip=@p
  [%pass /wire %agent [sip %clockwork] %poke [%noun !>(%print)]]
::  TODO don't do this poke
++  fake-pki-card
  [%pass /wire %agent [our.bowl %pki-store] %poke [%noun !>(%set-fake)]]
++  stop-card
  [%pass /wire %agent [our.bowl %clockstep] %poke [%noun !>(%stop)]]
++  nuke-cards
  :-  [%give %fact ~[/blocs] bloc-update+!>([%reset ~])]
  %+  turn  nodes  |=  sip=@p
  [%pass /wire %agent [sip %clockwork] %poke [%noun !>(%nuke)]]
++  addendum-card  ^-  card
  [%pass /addendum %arvo %b %wait (add now.bowl ~s2)] :: TODO time this properly
++  bloc-fact-card  ^-  card
  =/  update
    ::  ?:  (lth ~(wyt by history) 2)
      history
    ::  (lot:hon history `(sub ~(wyt by history) 2) `~(wyt by history))
  [%give %fact ~[/blocs] bloc-update+!>([%blocs update])]
++  pick-txns-from
  |=  =mempool
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
    (scag (sub needed count) (sort ~(tap in (~(key bi `^mempool`mempool) addr)) lth))
  =/  new-txns
    %+  turn  nonces
    |=  nonce=@ud
    (~(got bi `^mempool`mempool) addr nonce)
  $(count (add count (lent nonces)), txns [new-txns txns], mempool (~(del by `^mempool`mempool) addr))
++  trim-mempool
  |=  [=mempool txns=(list txn)]
  ^-  ^mempool
  ?~  txns  mempool
  ?.  ?=(txn-signed:ch i.txns)  $(txns t.txns)
  $(mempool (~(del bi mempool) who.i.txns nonce.i.txns), txns t.txns)
++  latest-key
  |=  =ship
  ^-  pass
  =/  top  (~(rep in (~(key bi pki-store) ship)) max)
  =/  key  (~(get bi pki-store) ship top)
  ?~  key  !!
  u.key
--

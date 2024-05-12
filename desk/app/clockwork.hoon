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
  `this
++  on-save   !>(state)
++  on-load
  |=  old-state=vase
  ::  dev
  on-init
 ::  prod
    :: :-  ~  this(state !<(state-0 old-state))
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
  ~&  ["++on-poke from" src.bowl]
  |^
  :: check various conditions for testing
  ?.  ?=(%noun mark)  [~ this]
    ::?:  ?=(%keys q.vase)
      ::~&  `signature`(sign-vote *vote)
      ::[~ this]
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
      ::  this relies on depth-first move order
      ::  reevaluate when breadth-first is close
      :_  this(robin nodes)  [stop-card:hd pki-leave-card:hd pki-cards:hd]
    ::  TODO pause poke?
    ::  actual checks
    ::  throw away unrecognized pokes
    =/  uaction  ((soft action) q.vase)
    ?~  uaction   
      ~&  [%unrecognized-action src.bowl q.vase]  [~ this]
    =/  action  (need uaction)
    ?-  -.action
      %start      (handle-start +.action)
      %broadcast  (handle-broadcast +.action)
      %txn        (handle-txn +.action)
      %faucet     (handle-faucet +.action)
    ==
  ++  handle-start
    |=  ts=@da
    ?>  =(src.bowl primary)
    ~&  handling-start=ts
    ?.  =(*bloc bloc.local)  [~ this]
    ~&  "bootstrapping"
    ~&  ["our.bowl" our.bowl]
    =/  init-bloc=bloc   [our.bowl ~ ts]
    =.  bloc.local  init-bloc
    =.  qc.local  ~
    ?.  .=(src.bowl i.robin)  [~ this]
    :_  this
    :-  (start-timer-card:hd ts)
        (bootstrap-cards:hd ts)
  ++  handle-broadcast
    |=  [=vote =quorum]  ^-  (quip card _this)
    ~&  ["broadcast" from=src.bowl h=height.vote r=round.vote s=stage.vote]
    ?:  (lth height.vote height.local)
      ~&  ["old height" src=height.vote our=height.local]
      [~ this]
    =/  sigs=(list signature)  ~(tap in quorum)
    |-
    ?~  sigs  [~ this]
    =/  sig  i.sigs
    =/  pass  (~(get bi pki-store) q.sig r.sig)
    ?~  pass
      ~&  "couldn't find key for {<q.sig>} {<r.sig>}"  $(sigs t.sigs)
    =/  keys  (com:nu:crub u.pass)
    ?.  (safe:as:keys p.sig (jam vote))
      ~&  ["received invalid vote" sig vote]
      $(sigs t.sigs)
    :: ~&  >  ["received valid vote" sig vote]
    $(sigs t.sigs, vote-store (~(put ju vote-store) vote sig))
  ++  handle-txn
    |=  =txn
    ?>  (gte (bex 10) (met 3 (jam txn)))
    ?.  ?=(txn-signed:ch txn)  [~ this]
    [~ this(mempool.local (~(put bi mempool.local) who.txn nonce.txn txn))]
  ++  handle-faucet
    |=  =addr
    =/  =txn-unsigned:ch
      :*  (latest-key our.bowl)
          faucet-nonce
          %ledger
          0
          [%send addr (bex 16)]
      ==
    =/  =txn-signed:ch  [(sigh:as:keys (jam txn-unsigned)) txn-unsigned]
    ~&  >>>  [txn-signed]
    =.  faucet-nonce  +(faucet-nonce)
    (handle-txn txn-signed)
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
      [%broadcast ~]
    ~?  ?=(%poke-ack -.sign)
      [%broadcast-acknowledged src.bowl]
    [~ this]
  ==
  ::  Main agent logic
  ++  handle-tick
    |=  count=@ud  ^-  (quip card _this)
    ?:  =(count 0)
      ~&  "[%chain %testnet-1 %sect] is brought to you by Red Horizon."  bail
    =/  [=round rem=@]
      ?:  =(count 0)
        [0 0]
      (dvr (dec count) 4)
    =/  =steppe  (steppe +(rem))
    ::  calculate leader
    =/  leader=node  (snag (mod round (lent robin)) `(list node)`robin)
    ~&  >>>  timer-pinged-at=[count=count height=height.local round=round steppe=steppe]
    ~&  >  current-time=[h m s]:(yell now.bowl)
    ::  ~&  >  nexttimer-at=[h m s]:(yell (add now.bowl delta))
    ~&  >  [height=height.local round=round step=steppe]
    ?-  steppe
        %1
      ~&  >>  leader=leader
      ::  In step 1 only the leader votes
      ?.  .=(our.bowl leader)  bail
      ::  If we are the leader we look for a qc in our vote store at the 
      ::  current height  that is more recent than our local state qc. 
      ::  If we find one, we vote for that and update our local
      ::  bloc and state.
      ::  If not, we propose our current local bloc with txns from our mempool
      =/  most-recent=(unit qc)
        (~(most-recent vs:lib vote-store) height.local)
      ::  ~&  most-recent=most-recent
      =?  local  ?&(!=(~ most-recent) !=(qc.local (need most-recent)))
        %=  local
          qc  most-recent
          bloc  bloc:(need most-recent)
        ==
      :_  this
      :: =/  =vote  [bloc.local height.local round %1]
      :: ~&  >  leader-vote=[bloc.local height=height.local round=round]
      (vote-and-broadcast [bloc.local height.local round %1])
        ::
        %2
      ::  In step 2 all nodes come to vote.
      ::  Nodes look for the latest vote by the leader
      =/  lbl=(unit qc)  (~(latest-by vs:lib vote-store) leader height.local)
      ::  If the leader didn't vote on step 1 we bail
      ::  bail meaning incrementing the step and doing nothing
      ?~  lbl  ~&  "no recent vote from leader found"  bail
      ::  We compare the bloc sent by the leader with our local height
      ::  If the leader's bloc is not at all more recent
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
      ::  If we received a new bloc from the leader we save that to local 
      ::  and vote for it
      =.  state
      %=  state
        bloc.local  bloc.u.lbl
        qc.local    ((flit valid:qcu:lib) u.lbl)
      ==
      :_  this
      ~&  >>  "voting {<bloc.local>}"
      (vote-and-broadcast [bloc.local height.local round %1])
        ::
        %3
      ::  In step 2 we should have received votes from 2/3 of the nodes 
      ::  for some block.
      ::  in the current height and round, and stage %1. We check for that.
      =/  valid  (~(valid-qcs vs:lib vote-store) height.local round %1)
      ::  If that's not the case we bail
      ?~  valid  ~&  "no valid qcs at stage 1"  bail
      ::  if there are more than one valid qcs, consider nuking
      ::  If good we update our state, and send a stage %2 (final vote).
      =.  state
      %=  state
        bloc.local  bloc.i.valid
        qc.local    (some i.valid)
      ==
      :_  this
      =/  vote  [bloc.i.valid height.local round %2]
      ~&  >>  voting=[height.local round %2]
      (vote-and-broadcast vote)
        %4
      ::  addendum must be scheduled on this step
      ::  crashes should be impossible
      ::
      ::  Same as above, we should have received 2/3 of stage %2 votes for something
      =/  valid  (~(valid-qcs vs:lib vote-store) height.local round %2)
      ::  consider: ?:  (gth (lent valid) 1)  nuke-network
      ::
      ::  If we didn't find a valid quorum we increment the step
      ::  and schedule the final addendum cleanup stage
      ?~  valid  ~&  "no valid qcs at stage 2"  schedule-addendum
      ::  If all good we commit the bloc to history, reset local bloc and qc,
      ::  increment height  then broadcast the qc of the committed bloc to 
      ::  sync everyone's vote store
      =/  valid-qc  i.valid
      ~&  >  ~
      ~&  >  block-commited=valid-qc
      ~&  >  ~
      =.  state
      %=  state
        history  (put:hon history height.local valid-qc)
        mempool.local  (~(trim mem:lib mempool.local) txns.bloc.valid-qc)
        height.local  +(height.local)
        bloc.local  [our.bowl ~(pick mem:lib mempool.local) now.bowl]
        qc.local    ~
      ==
      :: :_  increment-step
      :_  this
      :*  addendum-card:hd
          bloc-fact-card:hd
          (broadcast-cards:hd valid-qc)
      ==
    ==
  ++  vote-and-broadcast
    |=  =vote
    ^-  (list card)
    ~&  ["vote-and-broadcast" our=our.bowl]
    =/  =quorum  (~(get ju vote-store) vote)
    =.  quorum  (~(put in quorum) (sign-vote vote))
    (broadcast-cards:hd [vote quorum])
  ++  schedule-addendum
    :_  this
    :~  addendum-card:hd
    ==
  ++  bail
    ~&  "bail"
    [~ this]
  ++  sign-vote
    |=  =vote
    ^-  signature
    ~&  ["signing" our.bowl our-life]
    [(sigh:as:keys (jam vote)) our.bowl our-life]
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
    =/  init-txns=(list txn)
      ?~  t.valid  ~(pick mem:lib mempool.local)  ~
    =/  valid-qc  i.valid
    ~&  >  ~
    ~&  >  bloc-commited=valid-qc
    ~&  >  ~
    %=  $
      history  (put:hon history height.local valid-qc)
      height.local   +(height.local)
      bloc.local     [our.bowl init-txns now.bowl]
      qc.local       ~
      mempool.local  (~(trim mem:lib mempool.local) txns.bloc.i.valid)
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
++  pki-leave-card
  [%pass /pki-store %agent [our.bowl %pki-store] %leave ~]
++  broadcast-cards
  |=  p=[vote quorum]  ^-  (list card)
  ~&  >>  "broadcasting cards for {<bloc.p>}"
  %+  turn  nodes  |=  s=@p  (broadcast-card p s)
++  broadcast-card
  |=  [p=[vote quorum] sip=ship]  ^-  card
  [%pass /broadcast %agent [sip %clockwork] %poke [%noun !>([%broadcast p])]]
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
  [%pass /addendum %arvo %b %wait (add now.bowl addendum-delta)] :: TODO time this properly
++  bloc-fact-card  ^-  card
  =/  update
    ::  ?:  (lth ~(wyt by history) 2)
      history
    ::  (lot:hon history `(sub ~(wyt by history) 2) `~(wyt by history))
  [%give %fact ~[/blocs] bloc-update+!>([%blocs update])]
++  latest-key
  |=  =ship
  ^-  pass
  =/  top  (~(rep in (~(key bi pki-store) ship)) max)
  =/  key  (~(get bi pki-store) ship top)
  ?~  key  !!
  u.key
--

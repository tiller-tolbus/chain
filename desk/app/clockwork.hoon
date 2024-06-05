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
        =qc            ::  quorum certificate
        =mempool
      ==
    robin=(lest node)  ::  node order, round-robin
    =vote-store
    =history
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
    ::  dev
    ::  :-  fake-pki-card:hd
    [pki-watch-card:hd pki-cards:hd]
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
  :-  :~  ::
   ::
    ::[%pass /pki-store %agent [our.bowl %pki-store] %leave ~]
    [%pass /pki-store %agent [our.bowl %pki-store] %watch /pki-diffs]
  ::==  this
 ::  prod
     ==  this(state !<(state-0 old-state))
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
  ::~&  ["++on-poke from" src.bowl]
  |^
  :: check various conditions for testing
  ?.  ?=(%noun mark)  [~ this]
    ::?:  ?=(%keys q.vase)
      ::~&  `signature`(sign-vote *vote)
      ::[~ this]
    ?:  ?=(%reset q.vase)   :_  this  nuke-cards:hd
    ::?:  ?=(%sprint q.vase)  :_  this  dbug-cards:hd
    ::?:  ?=(%print q.vase)
    ::  =/  his  (bap:hon history)
    ::  ?~  his  ~&  >>>  "no blocs found"  [~ this]
    ::  ~&  >>  last-bloc=i.his  [~ this]
    ?:  ?=(%nuke q.vase)
      ?>  =(src.bowl primary)
      ~&  >>>  "nuking state"
      ::~&  >>  history=history
      =.  state  *state-0
      ::  :_  this(robin nodes)  [stop-card:hd fake-pki-card:hd pki-cards:hd]
      :_  this(robin nodes)  [stop-card:hd pki-watch-card:hd pki-cards:hd]
    ?:  ?=(%remind q.vase)
      ?>  =(src.bowl our.bowl)
      :_  this  [bloc-remind-card:hd]~
    ::  todo pause poke?
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
    ::~>  %bout.[0 %handle-broadcast]  
    ~&
    :*  
      %broadcast 
      from=src.bowl 
      h=height.vote 
      r=round.vote 
      s=stage.vote
      size=(met 3 (jam [vote quorum]))
    ==
    ?:  (gth (met 3 (jam +.vote)) (bex 4))
      ~&  %big-referendum  [~ this]
    ?:  (gth (met 3 (jam quorum)) max-quorum)
      ~&  %big-quorum  [~ this]  
    ?:  (gth (met 3 (jam bloc.vote)) max-bloc)
      ~&  %big-bloc  [~ this]
    ?:  (lth height.vote height.local)
      ::~&  ["old height" src=height.vote our=height.local]
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
    ?>  (gte max-txn (met 3 (jam txn)))
    ::~&  ["received txn" txn]
    ?:  (~(has bi mempool.local) who.txn nonce.txn)
      ::~&  ["duplicate txn" who=who.txn nonce=nonce.txn]  
      [~ this]
    ~&  [%txn-size (met 3 (jam txn))]
    :-  (txn-gossip-cards txn)
    this(mempool.local (~(put bi mempool.local) who.txn nonce.txn txn))
  ++  handle-faucet
    |=  =addr
    =/  =txn-unsigned
      :*  (latest-key our.bowl)
          faucet-nonce
          %ledger
          0
          [%send addr (bex 16)]
      ==
    =/  =txn  [(sigh:as:keys (jam txn-unsigned)) txn-unsigned]
    ~&  >>>  [txn]
    =.  faucet-nonce  +(faucet-nonce)
    :_  this  (txn-gossip-cards txn)
  --
++  on-peek
  |=  =(pole knot)
  ^-  (unit (unit cage))
  ?+  pole  ~&  %clockwork-bad-scry  !!
    [%x %vote-store ~]  ``[%noun !>(vote-store)]
  ==
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
    ~&  >>>  timer-pinged-at=[count=count]
    ~&  >>>  current-time=[h m s]:(yell now.bowl)
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
      ::  If not, we propose our current local bloc with txns 
      ::  from our mempool
      =/  most-recent=qc
        (~(most-recent vs:lib vote-store) height.local)
      ::  ~&  most-recent=most-recent
      =?  local  ?&(!=(~ most-recent) !=(qc.local (need most-recent)))
        %=  local
          qc    most-recent
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
      =/  lbl=(set voted-bloc)
        (~(latest-by vs:lib vote-store) leader round)
      ::  if set is greater than one, the leader is evil
      ?:  (gth ~(wyt in lbl) 1)
        ~&  [%byzantine-fault lbl]  bail
      ::  If the leader didn't vote on step 1, do nothing
      ?~  lbl  ~&  "no recent vote from leader found"  bail
      =/  lbl=[vote quorum]  n.lbl
      ~&  lbl
      ::  We compare the bloc sent by the leader with our local height
      ::  If the leader's bloc is not at all more recent
      ::  we bail as nothing new was received
      ?.  =(height.lbl height.local)
        ~&  "received bloc at incorrect height"
        bail
      ::  check to see if the leader sent us a more recent QC
      ::  if their QC is null, we accept their block
      =/  received-new=?
        ?|  =(bloc.local bloc.lbl)
          (as-recent:qcu:lib (certify:qcu:lib lbl) qc.local)
        ==
      ?.  received-new
        ~&  "vote from leader less recent than local"  bail
      =?  local  received-new
        %=  local
          qc    (certify:qcu:lib lbl)
          bloc  bloc.lbl
        ==
      :_  this
      ~&  >>  "voting on block by {<mint.bloc.local>}"
      (vote-and-broadcast [bloc.local height.local round %1])
        ::
        %3
      ::  In step 2 we should have received votes from 2/3 of the nodes
      ::  for some block.
      ::  in the current height and round, and stage %1. We check for that.
      =/  valid=(list qc)
        (~(valid-qcs vs:lib vote-store) height.local round %1)
      ::  If that's not the case we bail
      ?~  valid  ~&  "no valid qcs at stage 1"  bail
      ::  if there are more than one valid qcs, consider nuking
      ::  If good we update our state, and send a stage %2 (final vote).
      ?~  i.valid
        ~&  "valid-qcs malfunctioned"  bail
      =.  state
      %=  state
        bloc.local  bloc.u.i.valid
        qc.local    i.valid
      ==
      :_  this
      =/  vote  [bloc.u.i.valid height.local round %2]
      ~&  >>  voting=[height.local round %2]
      (vote-and-broadcast vote)
        %4
      ::  addendum must be scheduled on this step
      ::  crashes should be impossible
      ::
      ::  Same as above, we should have received 2/3 of stage %2 votes
      =/  valid=(list qc)
        (~(valid-qcs vs:lib vote-store) height.local round %2)
      ::  consider: ?:  (gth (lent valid) 1)  nuke-network
      ::
      ::  If we didn't find a valid quorum we increment the step
      ::  and schedule the final addendum cleanup stage
      ?~  valid  ~&  "no valid qcs at stage 2"  schedule-addendum
      ::  this should really never be null
      ?~  i.valid  ~&  "empty valid qc"  schedule-addendum
      ::  If all good we commit the bloc to history, reset local bloc and qc,
      ::  increment height  then broadcast the qc of the committed bloc to
      ::  sync everyone's vote store
      =/  valid-qc  u.i.valid
      ~&  >  ~
      ~&  >  block-committed=bloc.valid-qc
      ~&  >  ~
      =.  state
      %=  state
        vote-store  (~(prune vs:lib vote-store) height.local)
        history  (put:hon history height.local valid-qc)
        mempool.local  (~(trim mem:lib mempool.local) txns.bloc.valid-qc)
        height.local  +(height.local)
        bloc.local  [our.bowl ~(pick mem:lib mempool.local) now.bowl]
        qc.local    ~
      ==
      :: :_  increment-step
      :_  this
      :*  addendum-card:hd
          ::bloc-fact-card:hd
          (update-subs:hd valid-qc)
          (broadcast-cards:hd valid-qc)
      ==
    ==
  ++  vote-and-broadcast
    |=  =vote
    ::~>  %bout.[0 %vote-and-broadcast]
    ^-  (list card)
    ~&  ["vote-and-broadcast" our=our.bowl]
    =/  q=(unit quorum)  (~(get by vote-store) vote)
    =/  =quorum  (fall q ~)
    =.  quorum  (~(put in quorum) (sign-vote vote))
    (broadcast-cards:hd [vote quorum])
  ++  schedule-addendum
    :_  this
    :~  addendum-card:hd
    ==
  ++  bail
    ~&  "skipping step"
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
    ~>  %bout.[0 %addendum]
    ^-  (quip card _this)
    ::  In the addendum stage we look in our vote store for valid
    ::  qcs of stage %2 of a height >= our local height
    =/  valid=(list [vote quorum])
      (~(future-blocs vs:lib vote-store) height.local)
    ::  We then iterate through them and do what we did in step %4;
    ::  commit bloc to history, increment height, reset our local
    ::  bloc/qc and broadcast the committed bloc
    =|  new-cards=(list card)
    |-
    ?~  valid  [new-cards this]
    ::  only init-txns if we found new blocks, and only at the end
    =/  init-txns=(list txn)
      ?~  t.valid  ~(pick mem:lib mempool.local)  ~
    ::
    =/  new=[vote =quorum]  i.valid
    ?:  (gth height.new height.local)
      ~&  >>>  "missing block at height {<height.local>}"  $(valid t.valid)
    ?:  (has:hon history height.new)
      ~&  >>>  "duplicate block at height {<height.new>}"  $(valid t.valid)
    ~&  >  ~
    ~&  >  bloc-commited=bloc.new
    ~&  >  ~
    =.  mempool.local  (~(trim mem:lib mempool.local) txns.bloc.new)
    %=  $
      history  (put:hon history height.local new)
      vote-store  (~(prune vs:lib vote-store) height.local)
      height.local   +(height.local)
      bloc.local     [our.bowl init-txns now.bowl]
      qc.local       ~
      new-cards
        %+  weld  new-cards 
        ^-  (list card)
        :-  (update-subs:hd new)
        (broadcast-cards:hd new)
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
      pki-remind-card
  ==
++  pki-watch-card
  ::  subscribe to pki-store updates
  [%pass /pki-store %agent [our.bowl %pki-store] %watch /pki-diffs]
++  pki-leave-card
  [%pass /pki-store %agent [our.bowl %pki-store] %leave ~]
++  pki-remind-card
  [%pass /pki-store %agent [our.bowl %pki-store] %poke %noun !>(%remind)]
++  broadcast-cards
  |=  p=[vote quorum]  ^-  (list card)
  ::~&  >>  "broadcasting cards for {<bloc.p>}"
  %+  turn  nodes  
  |=  s=ship
  (broadcast-card p s)  
++  broadcast-card
  |=  [p=[vote quorum] sip=ship]  ^-  card
  [%pass /broadcast %agent [sip %clockwork] %poke [%noun !>([%broadcast p])]]
++  update-subs
  |=  p=[=vote =quorum]
  =/  his=^history
    (gas:hon:lib *^history ~[[height.vote.p [vote.p quorum.p]]])
  ~&  [%history-size (met 3 (jam his))]
  [%give %fact ~[/blocs] bloc-update+!>([%blocs his])]
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
  ?>  =(src.bowl our.bowl)
  :-  [%give %fact ~[/blocs] bloc-update+!>([%reset ~])]
  %+  turn  nodes  |=  sip=@p
  [%pass /wire %agent [sip %clockwork] %poke [%noun !>(%nuke)]]
++  addendum-card  ^-  card :: TODO time this properly
  [%pass /addendum %arvo %b %wait (add now.bowl addendum-delta)]
++  bloc-remind-card  ^-  card
  =/  update  history
  [%give %fact ~[/blocs] bloc-update+!>([%remind update])]
++  txn-gossip-cards
  |=  =txn
  ^-  (list card)
  %+  turn  nodes  |=  s=ship
  [%pass /txn-gossip %agent [s %clockwork] %poke [%noun !>([%txn txn])]]
++  latest-key
  |=  =ship
  ^-  pass
  =/  top  (~(rep in (~(key bi pki-store) ship)) max)
  =/  key  (~(get bi pki-store) ship top)
  ?~  key  0
  u.key
--

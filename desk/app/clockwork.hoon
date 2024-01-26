/-  *clockwork, pki=pki-store
/+  lib=clockwork,
    dbug,
    default-agent,
    mip
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
        =block
        qc=(unit qc)   ::  quorum certificate
        :: =round
        :: =step
      ==
                       ::  global state, this should sync among nodes
    robin=(lest node)  ::  node order, round-robin
    =history
    =vote-store
    ::  keys
    our-life=@ud
    keys=acru:ames
    =pki-store:pki
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
    default  ~(. (default-agent this %|) bowl)
::
++  on-init
  ~&  >  "%chain initialized"
  :_  this(robin nodes)
    :-  clockstep-watch-card:hd  
    :-  fake-pki-card:hd  pki-cards:hd
::
++  on-leave  |~(* [~ this])
++  on-fail   on-fail:default
++  on-save   !>(state)
++  on-load 
  |=  old-state=vase 
  :_  this(robin nodes)
    ::  dev
    :-  clockstep-watch-card:hd  
    :-  fake-pki-card:hd  pki-cards:hd
    ::  prod
    ::  ~
::
++  on-watch  |=(=(pole knot) [~ this])
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
      =/  his  (flop history)
      ?~  his  ~&  >>>  "no blocks found"  [~ this]
      ~&  >>  last-block=i.his  [~ this]
    ?:  ?=(%nuke q.vase)
      ~&  "nuking state"
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
    ==
  ++  handle-start
    |=  ts=@da
    ~&  handling-start=ts
    ?.  =(*block block.local)  [~ this]
    ~&  "bootstrapping"
    =/  init-block=block   [our.bowl eny.bowl ts height.local ~]
    =.  block.local  init-block
    =.  qc.local  ~
    ?.  .=(src.bowl i.robin)  [~ this]
    :_  this  
    :-  (start-timer-card:hd ts)
        (bootstrap-cards:hd ts)
  ++  handle-broadcast
    |=  =qc  ^-  (quip card _this)
    ?:  (lth height.qc height.local)
      ~&  "broadcast height below current"
      [~ this]
    =/  =vote  -.qc
    =/  sigs=(list signature)  ~(tap in quorum.qc)
    |-
    ?~  sigs  [~ this]
    =/  sig  i.sigs
    =/  pass  (~(get bi:mip pki-store) q.sig r.sig)
    ?~  pass  $(sigs t.sigs)
    =/  msg  (jam vote)
    =/  keys  (com:nu:crub u.pass)
    ?.  (safe:as:keys p.sig msg)
      $(sigs t.sigs)
    $(sigs t.sigs, vote-store (~(put ju vote-store) vote sig))
  --
++  on-peek   |=(=(pole knot) ~)  
++  on-agent  
  |=  [=(pole knot) =sign:agent:gall]
  |^
  :: ~>  %bout.[0 '%clockwork +on-agent']
  ?+  pole  [~ this]
      [%tick ~]
    ~&  ["received tick" wire=pole sign=sign]
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
        =/  new-pki-store  (~(put bi:mip pki-store) ship life pass)
        [~ this(pki-store new-pki-store)]
      ==
    ==
  ==
  ::  Main agent logic
  ++  handle-tick
    |=  count=@ud  ^-  (quip card _this)
    :: ~&  >  current-time=[m s f]:(yell now.bowl)
    :: ~&  >>  nexttimer-at=[m s f]:(yell (add now.bowl ~s3))  ::  uhm
    =/  [=round rem=@]  (dvr count 4)
    =/  =step  ;;(step +(rem))
    =/  l-robin  `(list node)`robin
    =/  leader=node  (snag (mod round (lent l-robin)) l-robin)
    ~&  >>>  timer-pinged-at=[pole height=height.local round=round step=step]
    ?-  step  ::  ~&  ["invalid step" step]  [~ this]
        %1
      ::  In step 1 only the leader votes
      ~&  >>  leader=leader
      ?.  .=(our.bowl leader)  bail
      ::  If we are the leader we look for a qc in our vote store at the current height
      ::  that is more recent (i.e. same height, higher round OR stage)
      ::  than our local state qc. If we find one, we vote for that and update our local
      ::  block and state. 
      ::  If not, we propose our current local block.
      =/  most-recent  (~(most-recent vs:lib vote-store) height.local)
      ~&  most-recent=most-recent
      =.  state  ?~  most-recent  state
      %=  state
        block.local  block.u.most-recent
        qc.local     (some u.most-recent)
      ==
      :: :_  increment-step
      :_  this
      %-  broadcast-cards:hd
      =/  =vote  [block.local height.local round %1]
      :: ~&  >  leader-vote=[block.local height=height.local round=round]
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
      ::  We compare the block sent by the leader with our local block
      ::  If the leader's block is not at all more recent (in height and (round or stage))
      ::  we bail as nothing new was received
      ?.  =(height.u.lbl height.local)
        ~&  "received block at incorrect height"
        bail
      =/  received-new=?
        ?~  qc.local  %.y
        (as-recent:qcu:lib u.lbl u.qc.local)
      ~&  >  received-new=received-new
      ?.  received-new
        ~&  "did not receive new block from leader"
        bail
      ::  If we correctly received a new block from the leader we save that to local state
      ::  and vote for it
      =.  state
      %=  state
        block.local  block.u.lbl
        qc.local     lbl
      ==
      :_  this
      =/  =vote  [block.u.lbl height.local round %1]
      ~&  >>  voting=[height.local round %1]
      (broadcast-and-vote:hd u.lbl vote)
        ::
        %3
      ::  In step 2 we should have received votes from 2/3 of the nodes for some block
      ::  in the current height and round, and stage %1. We check for that.
      =/  valid  (~(valid-qcs vs:lib vote-store) height.local round %1) 
      ::  If that's not the case we bail
      ?~  valid  ~&  "no valid qcs at stage 1"  bail
      ::  If good we update our state, and send a stage %2 (final vote).
      =.  state
      %=  state
        block.local  block.i.valid
        qc.local     (some i.valid)
      ==
      :_  this
      =/  vote  [block.i.valid height.local round %2]
      ~&  >>  voting=[height.local round %2]
      (broadcast-and-vote:hd i.valid vote)
        %4  
      ::  Same as above, we should have received 2/3 of stage %2 votes for something
      =/  valid  (~(valid-qcs vs:lib vote-store) height.local round %2)         
      ::  If we didn't find a valid quorum we increment the step 
      ::  and schedule the final addendum cleanup stage 
      ?~  valid  ~&  "no valid qcs at stage 2"  schedule-addendum
      ::  If all good we commit the block to history, reset local block and qc,
      ::  increment height
      ::  then broadcast the qc of the committed block to sync everyone's vote store
      =/  init-block  [our.bowl eny.bowl now.bowl +(height.local) ~]
      =.  state
      %=  state
        history  
          ~&  >>  block-commited=[h=height.local r=round who=mint.block.i.valid noun=(@uw noun.block.i.valid)]
          (snoc history block.i.valid)  
        height.local  +(height.local)
        block.local  init-block
        qc.local     ~
      ==
      :: :_  increment-step
      :_  this
      :-  addendum-card:hd
      (broadcast-cards:hd i.valid)
    ==
  ++  schedule-addendum
    :_  this
    :~  addendum-card:hd
    ==
  :: ++  increment-step
  ::   =/  new-step  ?-(step %1 %2, %2 %3, %3 %4, %4 %1)
  ::   ~&  ["increment step" new-step=new-step]
  ::   this(step new-step)
  ++  bail  
    :: ~&  ["bail on step" step]
    :: :-  ~  increment-step
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
  ::  %final stage of block syncing
  ++  handle-addendum
    ^-  (quip card _this)
    ::  In the addendum stage we look in our vote store for valid qcs of stage %2 of a height
    ::  greater than our local height 
    =/  valid  (~(future-blocks vs:lib vote-store) height.local)
    ::  We then iterate through them and do what we did in step %4; commit block to history,
    ::  increment height, reset our local block/qc and broadcast the committed block
    =|  new-cards=(list card)
    |-
    ?~  valid  [new-cards this]
    =/  init-block  [our.bowl eny.bowl now.bowl +(height.local) ~]            
    %=  $
      history  
        ~&  >>  block-commited=[h=height.local r=round who=mint.block.i.valid noun=(@uw noun.block.i.valid)]
        (snoc history block.i.valid)  
      height.local  +(height.local)
      block.local  init-block
      qc.local     ~
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
++  broadcast-and-vote
  |=  [p=qc =vote]
  ^-  (list card)
  =/  =signature  [(sigh:as:keys (jam vote)) our.bowl our-life]
  %+  roll  `(list @p)`nodes  |=  [i=@p acc=(list card)]
  %+  weld  acc
  :~  (broadcast-card p i)
      (vote-card signature vote i)
  ==
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
++  fake-pki-card
  [%pass /wire %agent [our.bowl %pki-store] %poke [%noun !>(%set-fake)]]
++  stop-card
  [%pass /wire %agent [our.bowl %clockstep] %poke [%noun !>(%stop)]]
++  nuke-cards
  %+  turn  nodes  |=  sip=@p
  [%pass /wire %agent [sip %clockwork] %poke [%noun !>(%nuke)]]
++  addendum-card  ^-  card
  [%pass /addendum %arvo %b %wait (add now.bowl ~s2)] :: TODO time this properly
--

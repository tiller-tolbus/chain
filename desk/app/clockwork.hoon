/-  *clockwork, pki=pki-store
/+  lib=clockwork, dbug, mip
|%
+$  versioned-state
$%  state-0
==
+$  state-0
$:  %0
    robin=(list node)  :: node order, round-robin
    $=  local           :: local variables from spec
      $:
        =height
        =block
        qc=(unit qc)   ::  quorum certificate
        =round
        =step
      ==
    =history
    =vote-store
    start-time=_~2050.1.1
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
::
++  on-init
~&  " "
~&  >  "%chain initialized"
:_  this(robin nodes)  watch-cards:hd
++  on-leave  |~(* [~ this])
++  on-fail   |~(* [~ this])
++  on-save   !>(state)
++  on-load   |=  old-state=vase 
:: =/  prev  !<(state-0 old-state)
:: [~ this](state prev)
:_  this(robin nodes)  [fake-pki-card:hd watch-cards:hd]
::
++  on-watch  |=(=(pole knot) [~ this])
++  on-poke   
  |=  [=mark =vase]
  |^
  ?.  ?=(%noun mark)  [~ this]
    ?:  ?=(%keys q.vase)  ~&
      `signature`[(sign:as:keys 1) our.bowl our-life]
      [~ this]
    ?:  ?=(%reset q.vase)   :_  this  nuke-cards:hd  
    ?:  ?=(%sprint q.vase)  :_  this  dbug-cards:hd  
    :: ?:  ?=(%print q.vase)   ~&  >>  state  [~ this]
    ?:  ?=(%print q.vase)
      =/  his  (flop history)
    ?~  his  ~&  >>>  "no blocks found"  [~ this]
      ~&  >>  last-block=i.his  [~ this]
    ?:  ?=(%nuke q.vase)   
      ~&  "nuking state"
      =.  state  *state-0
      :_  this(robin nodes)  [fake-pki-card:hd watch-cards:hd] 
    =/  uaction  ((soft action) q.vase)  :: TODO crash alert
    ?~  uaction  [~ this]
    =/  action  u.uaction
    ?-  -.action
      %start      (handle-start +.action)
      %broadcast  (handle-broadcast +.action)
      %vote       (handle-vote +.action)
    ==
  ++  handle-start
    |=  ts=@da
    ~&  handling-start=ts
    ?.  =(*block block.local)  [~ this]
    ~&  "bootstrapping"
    =/  init-block=block   [our.bowl eny.bowl ts height.local ~]
    :: =/  s=signature  [(sign:as:keys (jam init-block)) our.bowl our-life]
    :: =/  new-block  [s init-block]
    :: ~&  >  signing-block=eny.bowl
    =.  state
    %=  state
      block.local   init-block
      qc.local  ~
      start-time  ts
    ==
    ?~  robin  [~ this]
    ?.  .=(src.bowl i.robin)  [~ this]
    :_  this  
    :-  timer-card:hd
        (bootstrap-cards:hd ts)
  ++  handle-broadcast
    |=  =qc  ^-  (quip card _this)
    ~&  handling-broadcast=[src.bowl height.qc round.qc]
    ?:  (lth height.qc height.local)  ~&  "broadcast height below current"  [~ this]
    :-  ~  
    =/  old-quorum  (~(get by vote-store) -.qc)
    =/  nq  ?~  old-quorum  +.qc  (~(uni in u.old-quorum) +.qc)
    ~&  "commiting broadcast to store"
    %=  this
      vote-store  (~(put by vote-store) -.qc nq)
    ==
  ++  handle-vote
    |=  [s=signature =vote]
    ~&  handling-vote=[src.bowl height.vote round.vote stage.vote]
    ?.  =(height.vote height.local)  [~ this]
    =/  voter-keys  (~(get bi:mip pki-store) q.s r.s)
    ?~  voter-keys  ~&  "no keys found"  [~ this]
    =/  crub=acru:ames  (com:nu:crub:crypto u.voter-keys)
    =/  ver  (sure:as:crub p.s)
    ?~  ver  ~&  "leader signature on block untrue"  [~ this]
    :-  ~
    =/  old-quorum  (~(get by vote-store) vote)
    =/  nq  ?~  old-quorum  (silt ~[s])  (~(put in u.old-quorum) s)
    %=  this
      vote-store  (~(put by vote-store) vote nq)
    ==
  --
++  on-peek   |=(=(pole knot) ~)  
++  on-agent  
  |=  [=(pole knot) =sign:agent:gall]
  :: ~>  %bout.[0 '%clockwork +on-agent']
  ?+  pole  [~ this]
      [%pki-store ~]
    ?+  -.sign  [~ this]
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
++  on-arvo   
  |=  [=(pole knot) =sign-arvo]  
  ^-  (quip card _this)
  ~&  >>>  timer-pinged-at=[pole height=height.local round=round.local step=step.local]
  =/  next-timer  (find-time +(step.local))
  |^
  ?:  ?=(%jael -.sign-arvo)  (update-keys +.sign-arvo)
  ?.  ?=(%behn -.sign-arvo)  [~ this]
  ?+  pole  [~ this]
      [%step ~]  
    ~&  >  current-time=[m s f]:(yell now.bowl)
    ~&  >>  nexttimer-at=[m s f]:(yell next-timer)
    ?-  step.local
        %1
      ?~  robin  bail
      ~&  >>  leader=i.robin
      ?.  .=(our.bowl i.robin)  bail
      =/  most-recent  (~(most-recent vs:lib vote-store) height.local)
      ~&  most-recent=most-recent
      =.  state  ?~  most-recent  state
      %=  state
        block.local  block.u.most-recent
        qc.local     (some u.most-recent)
      ==
      :_  increment-step  :-  timer-card  %-  broadcast-cards:hd
      =/  =vote  [block.local height.local round.local %1]
      ~&  >  leader-vote=[block.local height=height.local round=round.local]
      [vote ~]
        ::
        %2  
      ?~  robin  bail
      =/  leader=node  i.robin
      :: =/  init-vs  ~(. vs vote-store)
      =/  lbl=(unit qc)  (~(latest-by vs:lib vote-store) leader)
      ?~  lbl  ~&  "no recent vote from leader found"  bail       
      ?.  (gte height.u.lbl height.local)  bail
      =/  received-new=?
        ?~  qc.local  %.y
        (as-recent:qcu:lib u.lbl u.qc.local)
      ~&  >  received-new=received-new
      :: ~&  [my-height=height lbl-height=height.u.lbl]
      :: ~&  [my-round=round lbl-round=round.u.lbl]
      ?.  received-new  bail
      =.  state
      %=  state
        block.local  block.u.lbl     
        qc.local     lbl
      ==
      :_  increment-step  :-  timer-card  
      =/  =vote  [block.u.lbl height.local round.local %1]
      ~&  >>  voting=[height.local round.local %1]
      (broadcast-and-vote:hd u.lbl vote)
        ::
        %3  
      =/  valid  (~(valid-qcs vs:lib vote-store) height.local round.local %1) 
      ?~  valid  ~&  "no valid qcs at stage 1"  bail
      =.  state
      %=  state
        block.local  block.i.valid
        qc.local     (some i.valid)
      ==
      :_  increment-step  :-  timer-card
      =/  vote  [block.i.valid height.local round.local %2]
      ~&  >>  voting=[height.local round.local %2]
      (broadcast-and-vote:hd i.valid vote)
        %4  
      =/  valid  (~(valid-qcs vs:lib vote-store) height.local round.local %2)         
      ?~  valid  ~&  "no valid qcs at stage 2"  addendum
      =/  init-block  [our.bowl eny.bowl now.bowl +(height.local) ~]
      :: =/  =signature  [(sign:as:keys (jam init-block)) our.bowl our-life]
      :: =/  new-block  [signature init-block]
      =.  state
      %=  state
        history  
          ~&  >>  block-commited=[h=height.local r=round.local who=mint.block.i.valid noun=(@uw noun.block.i.valid)]
          (snoc history block.i.valid)  
        height.local  +(height.local)
        block.local  init-block
        qc.local     ~
      ==
      :_  increment-step
      :-  addendum-card
      :-  timer-card
      (broadcast-cards:hd i.valid)
    ==
      [%addendum ~]  
    =/  valid  (~(future-blocks vs:lib vote-store) height.local)
    =|  new-cards=(list card)
    |-
    ?~  valid  :_  increment-round  new-cards
    =/  init-block  [our.bowl eny.bowl now.bowl +(height.local) ~]            
    :: =/  =signature  [(sign:as:keys (jam init-block)) our.bowl our-life]
    :: =/  new-block  [signature init-block]
    %=  $
      history  
        ~&  >>  block-commited=[h=height.local r=round.local who=mint.block.i.valid noun=(@uw noun.block.i.valid)]
        (snoc history block.i.valid)  
      height.local  +(height.local)
      block.local  init-block
      qc.local     ~ 
      new-cards  (weld new-cards (broadcast-cards:hd i.valid))
      valid  t.valid
    ==
   ==
  ++  increment-round
    %=  this
      round.local  +(round.local)
      robin  shuffle-robin
      step.local  %1
    ==
  ++  addendum
    :_  this  
    :~  addendum-card
        timer-card
    ==
  ++  shuffle-robin
    ?~  robin  robin
    (snoc t.robin i.robin)
  ++  increment-step
    =/  new-step  ?-(step.local %1 %2, %2 %3, %3 %4, %4 %1)
    this(step.local new-step)
  ++  bail  :_  increment-step  :~(timer-card)
  ::  %jael
  ++  update-keys
    |=  g=gift:jael
    ~&  updating-keys=g
    ?.  ?=(%private-keys -.g)  [~ this]
    =/  vein  vein.g
    =/  private-key  (~(get by vein) life.g)
    ?~  private-key  ~&  >>>  "private key not found"  [~ this]
    :-  ~
    %=  this
      our-life  life.g
      keys  (nol:nu:crub:crypto u.private-key)
    ==
  ++  addendum-card  ^-  card
    =/  ts  (sub next-timer (div ~s1 100))
    [%pass /addendum %arvo %b %wait ts]
  ++  timer-card  ^-  card
    [%pass /step %arvo %b %wait next-timer]
  --
--
|_  =bowl:gall
  ::
++  find-time  |=  stp=@ud  ^-  @da
  ~&  finding-time-for-step=stp
  %+  add  start-time
  %+  mul  delta
  %+  add  
  %+  mul  4  round.local  stp
::  cards
++  watch-cards
  ^-  (list card)
  :~  
    [%pass /private-keys %arvo %j %private-keys ~]
    ::  subscribe to pki-store updates
    [%pass /pki-store %agent [our.bowl %pki-store] %watch /pki-diffs]
  ==
++  broadcast-and-vote
  |=  [p=qc =vote]
  ^-  (list card)
  =/  =signature  [(sign:as:keys (jam vote)) our.bowl our-life]
  %+  roll  nodes  |=  [i=@p acc=(list card)]
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
  [%pass /wire %agent [sip %clockwork] %poke [%noun !>([%vote [s vote]])]]
::
++  timer-card  ^-  card
  [%pass /step %arvo %b %wait (find-time step.local)]
++  bootstrap-cards
  |=  ts=@da
  %+  turn  nodes  |=  sip=@p
  [%pass /wire %agent [sip %clockwork] %poke [%noun !>([%start ts])]]
++  dbug-cards
  %+  turn  nodes  |=  sip=@p
  [%pass /wire %agent [sip %clockwork] %poke [%noun !>(%print)]]
++  fake-pki-card
  [%pass /wire %agent [our.bowl %pki-store] %poke [%noun !>(%set-fake)]]
++  nuke-cards
  %+  turn  nodes  |=  sip=@p
  [%pass /wire %agent [sip %clockwork] %poke [%noun !>(%nuke)]]
--

/-  *clockwork, pki=pki-store
/+  dbug, mip
|%
+$  versioned-state
$%  state-0
==
+$  state-0
$:  %0
    robin=(list node)  :: node order, round-robin
    =height
    block=signed-block
    :: qc-store=(set (pair node qc))  :: pair of ship sending the qc and qc  
    =vote-store
    =qc   ::  quorum certificate
    =round
    =step
    =history
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
      ~&  >>  last-block=q.p.i.his  [~ this]
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
    ?.  =(*signed-block block)  [~ this]
    ~&  "bootstrapping"
    =/  init-block=^block   [eny.bowl ts height ~]
    =/  s=signature  [(sign:as:keys (jam init-block)) our.bowl our-life]
    =/  new-block  [s init-block]
    ~&  >  signing-block=eny.bowl
    =.  state
    %=  state
      block   new-block
      qc     [[new-block height round %1] ~]
      start-time  ts
    ==
    ?~  robin  [~ this]
    ?.  .=(src.bowl i.robin)  [~ this]
    :_  this  
    :-  timer-card:hd
        (bootstrap-cards:hd ts)
  ++  handle-broadcast
    |=  =^qc  ^-  (quip card _this)
    ~&  handling-broadcast=[src.bowl height.qc round.qc]
    ?:  (lth height.qc height)  ~&  "broadcast height below current"  [~ this]
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
    ?.  =(height.vote height)  [~ this]
    =/  voter-keys  (~(get bi:mip pki-store) src.bowl r.s)
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
  ~&  >>>  timer-pinged-at=[pole height=height round=round step=step]
  =/  next-timer  (find-time +(step))
  |^
  ?:  ?=(%jael -.sign-arvo)  (update-keys +.sign-arvo)
  ?.  ?=(%behn -.sign-arvo)  [~ this]
  ?+  pole  [~ this]
      [%step ~]  
    ~&  >  current-time=[m s f]:(yell now.bowl)
    ~&  >>  nexttimer-at=[m s f]:(yell next-timer)
    ?-  step
        %1
      ?~  robin  bail
      ~&  >>  leader=i.robin
      ?.  .=(our.bowl i.robin)  bail
      =/  most-recent  find-most-recent:hd
      ~&  most-recent=most-recent
      =.  state  ?~  most-recent  state
      %=  state
        block  block.u.most-recent
        qc     u.most-recent
      ==
      :_  increment-step  :-  timer-card  %-  broadcast-cards:hd
      =/  =vote  [block height round %1]
      ~&  >  leader-vote=[block height=height round=round]
      [vote ~]
        ::
        %2  
      =/  lbl  latest-by-leader:hd
      ::  this logic is faulty
      ?~  lbl  ~&  "no recent vote from leader found"  bail       
      =/  received-new  (as-recent-qc:hd u.lbl qc)
      ~&  >>>  received-new=received-new
      ~&  [my-height=height lbl-height=height.u.lbl]
      ~&  [my-round=round lbl-round=round.u.lbl]
      ::  fix this shit
      ?.  received-new  bail
      =.  state
      %=  state
        block  block.u.lbl     
        qc     u.lbl
      ==
      :_  increment-step  :-  timer-card  
      =/  =vote  [block.u.lbl height round %1]
      ~&  >>  voting=[height round %1]
      (broadcast-and-vote:hd u.lbl vote)
        ::
        %3  
      =/  valid  (valid-qcs:hd %1) 
      ?~  valid  ~&  "no valid qcs at stage 1"  bail
      =.  state
      %=  state
        block  block.i.valid
        qc     i.valid
      ==
      :_  increment-step  :-  timer-card
      =/  vote  [block.i.valid height round %2]
      ~&  >>  voting=[height round %2]
      (broadcast-and-vote:hd i.valid vote)
        %4  
      =/  valid  (valid-qcs:hd %2)         
      ?~  valid  ~&  "no valid qcs at stage 2"  addendum
      =/  init-block  [eny.bowl now.bowl +(height) ~]            
      =/  =signature  [(sign:as:keys (jam init-block)) our.bowl our-life]
      =/  new-block  [signature init-block]
      =.  state
      %=  state
        history  
          ~&  >>  block-commited=[h=height r=round who=q.p.block.i.valid noun=(@uw noun.q.block.i.valid)]
          (snoc history [p=block.i.valid q=i.valid])  
        height  +(height)
        block  new-block
        qc     [[new-block +(height) +(round) %1] ~]
      ==
      :_  increment-step
      :-  addendum-card
      :-  timer-card
      (broadcast-cards:hd i.valid)
    ==
      [%addendum ~]  
    =/  valid  future-blocks:hd
    =|  new-cards=(list card)         
    |-
    ?~  valid  :_  increment-round  new-cards
    =/  init-block  [eny.bowl now.bowl +(height) ~]            
    =/  =signature  [(sign:as:keys (jam init-block)) our.bowl our-life]
    =/  new-block  [signature init-block]
    %=  $
      history  
        ~&  >>  block-commited=[h=height r=round who=q.p.block.i.valid noun=(@uw noun.q.block.i.valid)]
        (snoc history [block.i.valid i.valid])  
      height  +(height)
      block  new-block
      qc     [[new-block +(height) +(round) %1] ~]
      new-cards  (weld new-cards (broadcast-cards:hd i.valid))
      valid  t.valid
    ==
   ==
  ++  increment-round
    %=  this
      round  +(round)
      robin  shuffle-robin
      step  %1
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
    =/  new-step  ?-(step %1 %2, %2 %3, %3 %4, %4 %1)
    this(step new-step)
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
++  future-blocks  ^-  (list ^qc)
  %+  sort
  %+  skim  ~(tap by vote-store)
  |=  i=^qc  ^-  ?
  ?&  %+  gte  ~(wyt in +.i)  (sm (lent nodes))
      (gte height.i height)
      .=(%2 stage.i)
  ==
  |=  [a=^qc b=^qc]  (gth height.a height.b)
++  valid-qcs  
  |=  stage=?(%1 %2)
  ^-  (list ^qc)  ::  there should only be one but w/e
  ~&  checking-qcs=[stage round height]
  %+  skim  ~(tap by vote-store)
  |=  i=^qc  ^-  ?
  :: ~&  >  qc=[stage.i round.i height.i ~(wyt in +.i)]
  ?&  %+  gte  ~(wyt in +.i)  (sm (lent nodes))
      .=(height height.i)
      .=(round round.i)
      .=(stage stage.i)
  ==
++  majority-qcs
  %+  skim  ~(tap by vote-store)
  |=  i=^qc  ^-  ?
  %+  gte  ~(wyt in +.i)  (sm (lent nodes))
++  latest-by-leader  ^-  (unit ^qc)
  ?~  robin  ~
  =/  leader  i.robin
  ~&  leader=[leader our.bowl height round]
  %+  roll  ~(tap by vote-store)
  |=  [i=^qc acc=(unit ^qc)]
  ?.  =(q.p.block.i leader)  acc
  :: validate signature
  =/  leader-keys  (~(get bi:mip pki-store) leader r.p.block.i)
  ?~  leader-keys  ~&  "leader keys not found"  acc
  =/  crub=acru:ames  (com:nu:crub:crypto u.leader-keys)
  =/  s=signature  -.block.i
  =/  ver  (sure:as:crub p.s)
  ?~  ver  ~&  "leader signature on block untrue"  acc
  ::
  ?.  =(height height.i)  acc
  ?~  acc  (some i)
  ?:  (more-recent-qc i u.acc)  (some i)  acc
++  find-most-recent  ^-  (unit ^qc)
  %+  roll  ~(tap by vote-store) 
  |=  [i=^qc acc=(unit ^qc)]
  ?.  (validate-qc i)  acc
  ?.  =(height height.i)  acc
  ?~  acc  (some i)
  ?:  (more-recent-qc i u.acc)  (some i)  acc
  ::
++  as-recent-qc
  |=  [a=^qc b=^qc]  ^-  ?
  ?:  (gte round.a round.b)  .y
  ?&  =(round.a round.b)
       (gte stage.a stage.b)
  ==
++  more-recent-qc
  |=  [a=^qc b=^qc]  ^-  ?
  ?:  (gth round.a round.b)  .y
  ?&  =(round.a round.b)
       (gth stage.a stage.b)
  ==
  ::
++  sm
  |=  a=@ud  ^-  @ud
  =/  q  (dvr (mul a 2) 3)
  ?:  .=(0 +.q)  -.q  +(-.q)
  ::
++  validate-qc
  |=  =^qc  ^-  ?
  %+  gte  ~(wyt in +.qc)  (sm (lent nodes))
++  find-time  |=  stp=@ud  ^-  @da
  ~&  finding-time-for-step=stp
  %+  add  start-time
  %+  mul  delta
  %+  add  
  %+  mul  4  round  stp
::  cards
++  watch-cards
  ^-  (list card)
  :~  
    [%pass /private-keys %arvo %j %private-keys ~]
    ::  subscribe to pki-store updates
    [%pass /pki-store %agent [our.bowl %pki-store] %watch /pki-diffs]
  ==
++  broadcast-and-vote
  |=  [p=^qc =vote]
  =/  =signature  [(sign:as:keys (jam vote)) our.bowl our-life]
  %+  roll  nodes  |=  [i=@p acc=(list card)]
  %+  weld  acc
  :~  (broadcast-card p i)
      (vote-card signature vote i)
  ==
++  broadcast-cards
  |=  p=^qc  ^-  (list card)
  %+  turn  nodes  |=  s=@p  (broadcast-card p s) 
++  broadcast-card
  |=  [p=^qc sip=ship]  ^-  card
  [%pass /wire %agent [sip %clockwork] %poke [%noun !>([%broadcast p])]]
++  vote-card
  |=  [s=signature =vote sip=@p]
  [%pass /wire %agent [sip %clockwork] %poke [%noun !>([%vote [s vote]])]]
::
++  timer-card  ^-  card
  [%pass /step %arvo %b %wait (find-time step)]
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

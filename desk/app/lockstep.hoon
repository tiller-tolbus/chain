/+  dbug, *lockstep
|%
+$  versioned-state
$%  state-0
==
+$  state-0
$:  %0
    robin=(list node)  :: node order, round-robin
    =height
    =block
    :: qc-store=(set (pair node qc))  :: pair of ship sending the qc and qc  
    =vote-store
    =qc   ::  quorum certificate
    =round
    =step
    =history
    start-time=@da
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
~
++  on-leave  |~(* `this)
++  on-fail   |~(* `this)
++  on-save   !>(state)
++  on-load   |=  old-state=vase 
:: =/  prev  !<(state-0 old-state)
:: `this(state prev)
`this(robin nodes)
::
++  on-watch  |=(=(pole knot) `this)
++  on-poke   
|=  [=mark =vase]
|^
?.  ?=(%noun mark)  `this
  =/  uaction  ((soft action) q.vase)  :: TODO crash alert
    ~&  >  action=[src.bowl uaction]
  ?~  uaction  `this
  =/  action  u.uaction
  ?-  -.action
  %start
    ?.  =(*^block block)  `this
    =/  init-block   [eny.bowl src.bowl ts.action]
    =.  state
    %=  state
      block   init-block
      qc     [[init-block height round %1] ~]
      start-time  ts.action
    ==
    ?~  robin  `this
    ?.  .=(src.bowl i.robin)  `this
    :_  this  
    :-  timer-card:hd
        (bootstrap-cards:hd ts.action)
      
  ::
  %broadcast  (handle-broadcast +.action)
  %vote       (handle-vote +.action)
  ==
  ++  handle-broadcast
  |=  =^qc  ^-  (quip card _this)
  ?:  (lth height.qc height)  `this
  :-  ~  
  =/  old-quorum  (~(get by vote-store) -.qc)
  
  =/  nq  ?~  old-quorum  +.qc  (~(uni in u.old-quorum) +.qc)
  %=  this
    vote-store  (~(put by vote-store) -.qc nq)
  ==
  ++  handle-vote
  |=  =vote
  ?.  =(height.vote height)  `this
  ::  signature-validation
  :-  ~
  =/  old-quorum  (~(get by vote-store) vote)
  =/  nq  ?~  old-quorum  (silt ~[src.bowl])  (~(put in u.old-quorum) src.bowl)
  %=  this
    vote-store  (~(put by vote-store) vote nq)
  ==
--
++  on-peek   |=(=(pole knot) ~)  
++  on-agent  
|=  [=wire =sign:agent:gall]
`this
++  on-arvo   
|=  [=(pole knot) =sign-arvo]  
|^
  ?.  ?=(%behn -.sign-arvo)  `this
    ~&  >  timer-pinged=[pole step]
  ?+  pole  `this
    [%step ~]  
      ?-  step
        %1  
          ?~  robin  bail
          ?.  .=(our.bowl i.robin)  bail
          =/  most-recent  find-most-recent:hd
          =.  state  ?~  most-recent  state
            %=  state
              block  block.u.most-recent
              qc     u.most-recent
            ==
            :_  increment-step  %-  broadcast-cards:hd
            =/  =vote  [block height round %1]
            [vote ~]
        ::
        %2  =/  lbl  latest-by-leader
            ?~  lbl  bail       
            =/  we-behind  (as-recent-qc:hd u.lbl qc)
            ?.  we-behind  bail
            =.  state
            %=  state
              block  block.u.lbl     
              qc     u.lbl
            ==
            :_  increment-step  
            =/  =vote  [block.u.lbl height round %1]
            (broadcast-and-vote:hd u.lbl vote)
                     
        %3  =/  valid  (valid-qcs %1) 
            ?~  valid  bail
            =.  state
            %=  state
              block  block.i.valid
              qc     i.valid
            ==
            :_  increment-step
            =/  vote  [block.i.valid height round %2]
            (broadcast-and-vote:hd i.valid vote)
            
        %4  =/  valid  (valid-qcs %2)         
            ?~  valid  addendum
            =/  init-block  [eny.bowl our.bowl now.bowl]            
            =.  state
            %=  state
              block  init-block
              qc     [[init-block +(height) +(round) %1] ~]
              history  
                ~&  >>  block-commited=block.i.valid
                (snoc history block.i.valid)  
              height  +(height)
            ==
            :_  increment-step
            :-  addendum-card:hd
            (broadcast-cards:hd i.valid)
      ==
        [%addendum ~]  
            =/  valid  future-blocks
            =|  new-cards=(list card)         
            |-
            ?~  valid  :_  increment-round  new-cards
            =/  init-block  [eny.bowl our.bowl now.bowl]            
            %=  $
              block  init-block
              qc     [[block +(height) +(round) %1] ~]
              history  
                ~&  >>  block-commited=block.i.valid
                (snoc history block.i.valid)  
              height  +(height)
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
      timer-card:hd
  ==
  ++  shuffle-robin
  ?~  robin  robin
  (snoc t.robin i.robin)
  ++  increment-step
  =/  new-step  ?-(step %1 %2, %2 %3, %3 %4, %4 %1)
  this(step new-step)
  ++  bail
  :_  increment-step  :~(timer-card:hd)
  --
--
|_   =bowl:gall
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
%+  skim  ~(tap by vote-store)
|=  i=^qc  ^-  ?
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
%+  roll  ~(tap by vote-store) 
|=  [i=^qc acc=(unit ^qc)]
?.  (validate-qc i)  acc
?.  =(mint.block.i leader)  acc
?.  =(height height.vote)  acc
?~  acc  (some i)
?:  (more-recent-qc i u.acc)  (some i)  acc

++  find-most-recent  ^-  (unit ^qc)
%+  roll  ~(tap by vote-store) 
|=  [i=^qc acc=(unit ^qc)]
?.  (validate-qc i)  acc
?.  =(height height.vote)  acc
?~  acc  (some i)
?:  (more-recent-qc i u.acc)  (some i)  acc

::

++  as-recent-qc
|=  [a=^qc b=^qc]  ^-  ?
  ?:  (lth round.a round.b)  .n
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
::  signature validation goes here
%+  gte  ~(wyt in +.qc)  (sm (lent nodes))
::  cards
++  broadcast-and-vote
|=  [p=^qc =vote]
:-  timer-card
%+  roll  nodes  |=  [i=@p acc=(list card)]
%+  weld  acc
:~  (broadcast-card p i)
    (vote-card vote i)
==
++  broadcast-cards
|=  p=^qc  ^-  (list card)
  :-  timer-card
  %+  turn  nodes  |=  s=@p  (broadcast-card p s) 

++  broadcast-card
|=  [p=^qc sip=ship]  ^-  card
[%pass /wire %agent [sip %lockstep] %poke [%noun !>([%broadcast p])]]
++  vote-card
|=  [=vote sip=@p]
[%pass /wire %agent [sip %lockstep] %poke [%noun !>([%vote vote])]]
++  addendum-card  ^-  card
[%pass /addendum %arvo %b %wait (add delta (sub now.bowl (div ~s1 100)))]
::
++  find-time  ^-  @da
%+  add  start-time
%+  mul  delta
%+  add  
%+  mul  4  round
(dec step)
::
++  timer-card  
~&  timer-card=find-time
^-  card
[%pass /step %arvo %b %wait find-time]
++  bootstrap-cards
|=  ts=@da
%+  turn  nodes  |=  sip=@p
[%pass /wire %agent [sip %lockstep] %poke [%noun !>([%start ts])]]
--

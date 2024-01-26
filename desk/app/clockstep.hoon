/+  dbug
|%
+$  versioned-state
$%  state-0
==
+$  state-0
$:  %0
    start-time=@da
    count=@ud
    stop=$~(%.y ?)
    ::dev
    delta=_~s3
==
+$  card  card:agent:gall
::  prod  
::  ++  delta  ~s3  
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
++  on-leave  |~(* `this)
++  on-fail   |~(* `this)
++  on-save   !>(state)
++  on-load   |=  old-state=vase 
  =/  prev  !<(state-0 old-state)
  [~ this(state prev)]
++  on-init  [~ this]
++  on-peek  |=(=(pole knot) ~)  
++  on-poke   
  |=  [=mark =vase] 
  ?.  .=(src.bowl our.bowl)  [~ this]
  ?.  ?=(%noun mark)  [~ this]
  ::  dev
  ?:  ?=([%delta @dr] q.vase)  :-  ~  this(delta +.q.vase)
  ::  prod
  ?+  q.vase  [~ this]
      [%start @da]
    :-  :~((timer-card +.q.vase))
    this(stop %.n, start-time +.q.vase, count 0)
      %stop
    [~ this(stop %.y)]  
  ==
  ::
++  on-watch  
  |=  =(pole knot)
  ~&  ["clockstep: on-watch" pole]
  :: Only allow %tick subscriptions from our own %clockwork agent
  ?.  .=(src.bowl our.bowl)  !!
  ?.  .=(/gall/clockwork sap.bowl)  !!
  ?.  ?=([%tick ~] pole)  !!  [~ this]
++  on-agent  |=([=wire =sign:agent:gall] [~ this])
++  on-arvo   
  |=  [=(pole knot) =sign-arvo]  
  ?.  ?=(%behn -.sign-arvo)  [~ this]
  ~&  ["clockstep: behn" pole]
  ?+  pole  [~ this]
      [%delta ~] 
    ?:  stop  [~ this]
    :_  this(count +(count))
    ~[fact-card:hd (timer-card:hd (add start-time (mul delta count)))]
  ==
--
|_  =bowl:gall
++  timer-card  
  |=  =time  ^-  card
  [%pass /delta %arvo %b %wait (add delta time)]
++  fact-card  ^-  card
  :: ~&  "giving fact"
  [%give %fact ~[/tick] [%noun !>(count)]]
--

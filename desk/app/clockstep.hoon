/+  dbug
|%
+$  versioned-state
$%  state-0
==
+$  state-0
$:  %0
    start-time=@da
    count=@ud
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
++  on-peek   |=(=(pole knot) ~)  
++  on-poke   
  |=  [=mark =vase] 
  ?.  ?=(%noun mark)  [~ this]
  ::  dev
  ?:  ?=([%delta @dr] q.vase)  :-  ~  this(delta +.q.vase)
  ::  prod
  ?:  ?=([%start @da] q.vase)  :-  :~((timer-card +.q.vase))
    this(start-time +.q.vase)
  ::
  [~ this]
++  on-watch  
  |=  =(pole knot)
  :: Only allow %delta subscriptions from our own %clockwork agent
  ?.  .=(src.bowl our.bowl)  !!
  ?.  .=(/gall/clockwork sap.bowl)  !!
  ?.  ?=([%delta ~] pole)  !!  [~ this]
++  on-agent  |=([=wire =sign:agent:gall] [~ this])
++  on-arvo   
  |=  [=(pole knot) =sign-arvo]  
  ?.  ?=(%behn -.sign-arvo)  [~ this]
  ?+  pole  [~ this]
      [%delta ~]  =.  count  +(count)
    :_  this  ~[fact-card:hd (timer-card:hd now.bowl)]
  ==
--
|_  =bowl:gall
++  timer-card  
  |=  =time  ^-  card
  [%pass /delta %arvo %b %wait (add delta time)]
++  fact-card  ^-  card
  [%give %fact ~[/tick] [%noun !>(count)]]
--
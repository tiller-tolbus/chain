/-  cw=clockwork
/+  default-agent, dbug
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0  =history:cw
+$  card  card:agent:gall
--
=|  state-0
=*  state  -
=<
%-  agent:dbug
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
    cor   ~(. +> [bowl ~])
++  on-init
  =^  cards  state
    abet:init:cor
  [cards this]
++  on-peek  peek:cor
++  on-save  !>([state])
++  on-load
  |=  =vase
  ^-  (quip card _this)
  =^  cards  state
    abet:(load:cor vase)
  [cards this]
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  =^  cards  state
    abet:(agent:cor wire sign)
  [cards this]
::  TODO poke to sign and broadcast transaction
++  on-poke   on-poke:def
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
|_  [=bowl:gall cards=(list card)]
++  abet  [(flop cards) state]
++  cor   .
++  emit  |=(=card cor(cards [card cards]))
++  emil  |=(caz=(list card) cor(cards (welp (flop caz) cards)))
++  give  |=(=gift:agent:gall (emit %give gift))
++  init
  ^+  cor
  =.  history  ~
  watch-blocks
++  load
  |=  =vase
  ^+  cor
  =/  old  !<(state-0 vase)
  =.  state  old
  cor
++  peek
  |=  =(pole knot)
  ^-  (unit (unit cage))
  ?>  ?=(^ pole)
  ?+  pole  [~ ~]
    [%x %v0 %history ~]  ``history+!>(history)
  ==
++  agent
  |=  [=(pole knot) =sign:agent:gall]
  ^+  cor
  ?+  pole  ~|(bad-agent-wire+pole !!)
      [%blocks ~]
    ?+  -.sign  !!
        %kick  watch-blocks
        %watch-ack
      ?~  p.sign
        cor
      ((slog leaf+"failed subscription to blocks" u.p.sign) cor)
        %fact
      (take-blocks !<(history:cw q.cage.sign))
    ==
  ==
++  take-blocks
  |=  update=history:cw
  ^+  cor
  ?~  update  cor
  ?:  (gth height.i.update (lent history))  cor
  ?:  =(height.i.update (lent history))
    cor(history (weld history update))
  $(update t.update)
++  watch-blocks
  ::  TODO subscribe to 1/3rd + 1 random nodes
  ::  TODO if I'm a node listen to myself
  ::  TODO verify signatures on blocks
  ::  TODO get initial state with a remote scry and only subscribe to new blocks
  =/  who  ~zod
  (emit %pass /blocks %agent [who %clockwork] %watch /blocks)
--

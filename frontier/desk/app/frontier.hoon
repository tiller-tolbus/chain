/-  *frontier
/+  default-agent,
    dbug,
    *frontier
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0
  $:  %0
      ::  accepted txs in dag are our history
      ::  proposed txs in dag are our frontier
      =dag
  ==
+$  card  card:agent:gall
--
%-  agent:dbug
=|  state-0
=*  state  -
^-  agent:gall
|_  =bowl:gall
+*  this     .
    default  ~(. (default-agent this %|) bowl)
++  on-init   on-init:default
++  on-save   !>(state)
++  on-load
  |=  old=vase
  ^-  [(list card) _this]
  :-  ^-  (list card)
      ~
  %=  this
    state  !<(state-0 old)
  ==
++  on-poke
  |=  [=mark =vase]
  ^-  [(list card) _this]
  ?>  ?=(%frontier-action mark)
  =/  axn  !<(action vase)
  [~ this]
::
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?+  path  (on-peek:default path)
    [%x %dag ~]  [~ ~ [%noun !>(dag)]]
  ==
++  on-watch
  |=  =path
  ^-  [(list card) _this]
  ?>  ?=([%dag ~] path)
  :-  ^-  (list card)
      :~  [%give %fact ~ %frontier-answer !>(`answer`[%vote ~])]
      ==
  this
++  on-arvo   on-arvo:default
++  on-leave  on-leave:default
++  on-agent  on-agent:default
++  on-fail   on-fail:default
--

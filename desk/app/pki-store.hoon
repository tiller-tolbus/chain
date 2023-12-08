/-  *pki-store,
    dice
/+  dbug,
    default-agent,
    verb,
    naive
::
|%
+$  versioned-state  $%(state-zero)
::
+$  state-zero
  $:  %zero
      =logs
      =points:points:naive
      =store
  ==
+$  card  card:agent:gall
+$  sign  sign:agent:gall
--
::
%+  verb  &
%-  agent:dbug
=|  state-zero
=*  state  -
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
++  on-init
  ^-  (quip card _this)
  :_  this
  :~  [%pass /pki-store %agent [our.bowl %azimuth] %watch /event]
  ==
::
++  on-save
  ^-  vase
  !>(state)
::
++  on-load
  |=  old-state=vase
  ^-  (quip card _this)
  ?>  ?=([%zero *] q.old-state)
  `this(state !<(state-zero old-state))
::
++  on-poke
  |=  =cage
  ^-  (quip card _this)
  !!
::
++  on-watch
  |=  path
  ^-  (quip card _this)
  !!
::
++  on-leave
  |=  path
  ^-  (quip card _this)
  !!
::
++  on-peek
  |=  path
  ^-  (unit (unit cage))
  !!
::
++  on-agent
  |=  [=wire =sign]
  ^-  (quip card _this)
  ?.  ?=([%pki-store ~] wire)
    (on-agent:def wire sign)
  ?.  ?=(%fact -.sign)
    (on-agent:def wire sign)
  ?+  p.cage.sign  (on-agent:def wire sign)
      %naive-state
    =/  snapshot  !<([=^state:naive * *] q.cage.sign)
    =/  points  points:state:snapshot
    =/  pairs=(list [=ship =point:naive])  ~(tap by points)
    =|  store=(mip ship [life rift] pass)
    =/  store
    |-
    ^+  store
    ?~  pairs  store
    =/  pair=[=ship =point:naive]  i.pairs
    =/  =life  life.keys.net.point.pair
    =/  =rift  rift.net.point.pair
    ::  if crypt.keys doesn't work, try auth.keys
    =/  =pass  crypt.keys.net.point.pair
    %=  $
      pairs  t.pairs
      store  (~(put bi store) ship.pair [life rift] pass)
    ==
    ::%+  turn  ships
    ::|=  [ship point:naive]
    ::^-  store ::  (mip ship [life rift] pass)
    ::  TODO: parse state into store
    `this(points points, store store)
      %naive-diffs
    =/  naive-diff  !<(diff:naive q.cage.sign)
    ::  TODO: parse diff into store
    `this(logs (snoc logs naive-diff))
  ==
::
++  on-arvo
  |=  [wire =sign-arvo]
  ^-  (quip card _this)
  !!
::
++  on-fail
  |=  [term tang]
  ^-  (quip card _this)
  !!
--
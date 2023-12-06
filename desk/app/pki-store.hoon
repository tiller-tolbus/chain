/-  pki-store,
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
      =logs:pki-store
      =points:points:naive
      =store:pki-store
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
    =+  !<([s=^state:naive owners:dice sponsors:dice] q.cage.sign)
    ::  TODO: parse state into store
    `this(points points:s)
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
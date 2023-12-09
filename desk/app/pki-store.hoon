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
      =pki-store
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
  ::  this is the only valid path
  ?>  =(path /pki-diffs)
  [~ this]
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
  ?+  -.sign  (on-agent:def wire sign)
      ::
      %kick
    :_  this
    :~  [%pass /pki-store %agent [our.bowl %azimuth] %watch /event]
    ==
      %watch-ack
    ~&  ["watch-ack" wire sign]
    [~ this]
      ::
      %fact
    ~&  ["on-agent hit" -.sign p.cage.sign]
    ?+  p.cage.sign  (on-agent:def wire sign)
        ::
        %naive-state
      =/  snapshot  !<([=^state:naive * *] q.cage.sign)
      =/  points  points:state:snapshot
      =/  entries=(list pki-entry)
        %+  turn  ~(tap by points)
        |=  [=ship =point:naive]
        ^-  pki-entry
        ::  if crypt.keys doesn't work, try auth.keys
        [ship life.keys.net.point crypt.keys.net.point]
      =|  new-store=^pki-store
      =/  new-store
      |-
      ^+  new-store
      ?~  entries  new-store
      =+  i.entries
      %=  $
        entries  t.entries
        new-store  (~(put bi new-store) ship life pass)
      ==
      :_  this(pki-store new-store)
      :~  [%give %fact ~[/pki-diffs] %pki-snapshot !>(new-store)]
      ==
        ::
        %naive-diffs
      ~&  ["%naive-diffs hit" sign]
      =/  diff  !<(diff:naive q.cage.sign)
      ~&  ["diff" diff]
      ?.  ?=([%point =ship %keys =keys:naive] diff)
        [~ this]
      =/  =pki-entry  [ship.diff life.keys.diff crypt.keys.diff]
      ~&  ["azimuth update" -]
      =+  pki-entry
      :_  this(pki-store (~(put bi pki-store) ship life pass))
      :~  [%give %fact ~[/pki-diffs] %pki-diff !>(pki-entry)]
      ==
    ==
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
  ~&  [term tang]
  !!
--
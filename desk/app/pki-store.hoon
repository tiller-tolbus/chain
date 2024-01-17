/-  *pki-store,
    dice
/+  dbug,
    default-agent,
    verb,
    naive,
    azimuth
::
|%
+$  versioned-state  $%(state-zero)
::
+$  state-zero
  $:  %zero
      =pki-store
      fake=_|
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
  ~>  %bout.[0 '%pki-store +on-init']
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
  |=  [=mark =vase]
  |^
    ^-  (quip card _this)
    ?.  ?=(%noun mark)  `this
    ?:  ?=(%set-fake q.vase)
      ~&  >  pki-store-setting-fake=[src.bowl]
      =/  fake-store  populate-fake-store
      :_  %=  this
            fake  .y
            pki-store  fake-store
          ==
      :~  [%pass /pki-store %agent [our.bowl %azimuth] %leave ~]
          [%give %fact ~[/pki-diffs] %pki-snapshot !>(fake-store)]
      ==
    `this
    ++  populate-fake-store  ^+  pki-store
    =/  store  *^pki-store
    :: =/  ships  (gulf ~zod ~fipfes)
    :: =/  ships  (gulf ~zod ~fes)
    =/  ships  (gulf ~zod ~wes)
    |-
    ?~  ships  store
    =+  .^([=life =pass (unit @ux)] %j /(scot %p our.bowl)/deed/(scot %da now.bowl)/(scot %p i.ships)/1)
    %=  $
      store  (~(put bi store) i.ships life pass)
      ships  t.ships
    ==
  --
::
++  on-watch
  |=  =path
  ~>  %bout.[0 '%pki-store +on-watch']
  ~&  path
  ^-  (quip card _this)
  ::  this is the only valid path
  ?>  =(path /pki-diffs)
  :_  this
  :~  [%give %fact ~[/pki-diffs] %pki-snapshot !>(pki-store)]
  ==
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
  ~>  %bout.[0 '%pki-store %on-agent']
  ~&  pki-store=[wire -.sign]
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
    [~ this]
      ::
      %fact
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
        =+  keys.net.point
        =/  crypt  (as-octs:mimes:html crypt)
        =/  auth  (as-octs:mimes:html auth)
        =/  =pass  (pass-from-eth.azimuth crypt auth suite)
        [ship life pass]
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
      =/  diff  !<(diff:naive q.cage.sign)
      ?.  ?=([%point =ship %keys =keys:naive] diff)
        [~ this]
      =/  =pki-entry  [ship.diff life.keys.diff auth.keys.diff]
      =+  pki-entry
      :_  this(pki-store (~(put bi pki-store) ship life pass))
      :~  [%give %fact ~[/pki-diffs] %pki-diff !>(pki-entry)]
      ==
    ==
  ==
::
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  !!
::
++  on-fail
  |=  [=term =tang]
  ~>  %bout.[0 '%pki-store +on-fail']
  ^-  (quip card _this)
  ~&  term
  (mean tang)
--

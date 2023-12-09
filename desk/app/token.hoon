/-  *token
/+  dbug,
    default-agent,
    verb
::
|%
::
+$  versioned-state  $%(state-zero)
::
+$  state-zero
  $:  %zero
      =chain
      keys=acru:ames
      pend=(set txn)     :: cryptographically verified but unauthenticated
      ltid=@ud           :: last used txn id
      shared=shared-state
  ==
::
::  boilerplate
::
+$  card  card:agent:gall
--
::
%+  verb  &
%-  agent:dbug
=|  state-zero
=*  state  -
::
^-  agent:gall
::
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
++  on-init
  ^-  (quip card _this)
  ~>  %bout.[0 '%token +on-init']
  :-
  ::  subscribe to private keys from jael
  :~  [%pass /token/jael/private-keys %arvo %j %private-keys ~]
  ==
  ::  bootstrap shared state
  this(shared bootstrap-state)
::
++  on-save
  ^-  vase
  ~>  %bout.[0 '%token +on-save']
  !>(state)
::
++  on-load
  |=  =vase
  ~>  %bout.[0 '%token +on-load']
  ^-  (quip card _this)
  ?>  ?=([%zero *] q.vase)
  `this(state !<(state-zero vase))
::
++  on-poke
  |=  [=mark =vase]
  ~>  %bout.[0 '%token +on-poke']
  ^-  (quip card _this)
  ::  add: assert on mark
  =/  action  !<(token-action vase)
  ?-  -.action
    ::
    ::  receive txn from client
      %local-txn
    =.  ltid  +(ltid)
    =/  src  src.txn-data-user.action
    =/  =txn-data
      :+  tim=now.bowl
        tid=ltid
      txn-data-user.action
    =/  =txn  [(sign:as:keys (jam txn-data)) txn-data]
    =/  new-cards=(list card)
      :: validator notification
      :: TODO: use real marks
      =/  =cage  [%noun !>(txn)]
      ^-  (list card)
      %+  turn  ~(tap in validators.shared)
      |=  val=@p
      [%pass /token/remote-txn/(scot %ud tid.txn) %agent [val %token] %poke cage]
    [new-cards this]
    ::
    ::   receive a remote txn
      %remote-txn
    ::  when we have pubkeys, check signature
    =.  pend  (~(put by pend) txn.action)
    [~ this]
    ::
      %bootstrap
    ?>  =(~ chain)
    =/  genesis=block-data
      :*  hght=0
          prev=(shax ~)
          stmp=now.bowl
          mint=our.bowl
          slsh=%.n
          txns=~
      ==
    =/  hashed-block=[@uvH block-data]  [(shax (jam genesis)) genesis]
    =/  signed-block  ;;([@ @] (cue (sign:as:keys (jam hashed-block))))
    =/  block  ;;(block [-.signed-block (cue +.signed-block)])
    `this(chain ~[block])
  == 
::
++  on-peek
  |=  pat=path
  ~>  %bout.[0 '%token +on-peek']
  ^-  (unit (unit cage))
  [~ ~]
::
++  on-agent
  |=  [wir=wire sig=sign:agent:gall]
  ~>  %bout.[0 '%token +on-agent']
  ^-  (quip card _this)
  `this
::
++  on-arvo
  |=  [=wire sign=sign-arvo]
  ~>  %bout.[0 '%token +on-arvo']
  ^-  (quip card _this)
  ?+    wire  ~|(%bad-wire !!)
    ::   [%token tsrc=@ ttid=@ ~]
    :: ?+    sign  ~|(%bad-arvo-sign !!)
    ::     [%ames %tune *]
    ::   ::  remote scry request handler
    ::   =/  roar  roar.sign
    ::   ?~  roar  ~|(%empty-roar !!)
    ::   ::  verify remote scry response is marked %token-txn
    ::   ?>  =(%noun p:(need q.dat.u.roar))
    ::   ::  itxn: incoming TXN
    ::   =/  itxn=txn  ;;(txn q:(need q.dat.u.roar))
    ::   =/  =txn-seed  [src=src.itxn tid=tid.itxn hax=(shax (jam itxn))]
    ::   ::  verify itxn matches attested hash from txn-seed
    ::   ?.  (~(has in pend) txn-seed)
    ::     ~|(%bad-hash !!)
    ::   ::  valid TXN, promote to pending for chain
    ::   =.  pend  (~(put in pend) itxn)
    ::   `this
    :: ==
    ::
      [%token %jael %private-keys ~]
    ?>  ?=([%jael %private-keys *] sign)
    =/  life  life.sign
    =/  vein  vein.sign
    =/  private-key=ring  (~(got by vein) life)
    `this(keys (nol:nu:crub:crypto private-key))
  ==
::
++  on-watch
  |=  pat=path
  ~>  %bout.[0 '%token +on-watch']
  ^-  (quip card _this)
  `this
::
++  on-fail
  ~>  %bout.[0 '%token +on-fail']
  on-fail:def
::
++  on-leave
  ~>  %bout.[0 '%token +on-leave']
  on-leave:def
--
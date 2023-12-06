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
      pend=(set seed)    :: unverified, unauthenticated
      pent=(set txn)     :: cryptographically verified but unauthenticated
      full=?             :: flag for full node vs. lite node
      want=?             :: intent to be validator, should sync w/ global
      boot=@p            :: bootstrap node for chain state  XX default
      ltid=@ud           :: last used txn id
      :: ktid=(map @p @ud)  :: courtesy cache of known nonces for breaches (or Pine solves?)
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
=<
  |_  =bowl:gall
  +*  this  .
      def   ~(. (default-agent this %|) bowl)
      eng   ~(. +> [bowl ~])
  ++  on-init
    ^-  (quip card _this)
    ~>  %bout.[0 '%token +on-init']
    =^  cards  state  abet:init:eng
    [cards this]
  ::
  ++  on-save
    ^-  vase
    ~>  %bout.[0 '%token +on-save']
    !>(state)
  ::
  ++  on-load
    |=  ole=vase
    ~>  %bout.[0 '%token +on-load']
    ^-  (quip card _this)
    =^  cards  state  abet:(load:eng ole)
    [cards this]
  ::
  ++  on-poke
    |=  cag=cage
    ~>  %bout.[0 '%token +on-poke']
    ^-  (quip card _this)
    =^  cards  state  abet:(poke:eng cag)
    [cards this]
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
    |=  [wir=wire sig=sign-arvo]
    ~>  %bout.[0 '%token +on-arvo']
    ^-  (quip card _this)
    =^  cards  state  abet:(arvo:eng wir sig)
    [cards this]
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
|_  [bol=bowl:gall dek=(list card)]
+*  dat  .
++  emit  |=(=card dat(dek [card dek]))
++  emil  |=(lac=(list card) dat(dek (welp (flop lac) dek)))
++  abet  ^-((quip card _state) [(flop dek) state])
::
++  init
  ^+  dat
  ::
  ::  bootstrap shared-state
  ::  there is good reason to include this mechanic at a protocol level
  ::  but these specific values are for prototyping only
  =+  ^-  shared-state
    :*
      ledger=(molt ~[[our.bol 1.000.000]])
      validators=~[our.bol]
      blacklist=~
    ==
  dat(shared -)
::
++  load
  |=  vaz=vase
  ^+  dat
  ?>  ?=([%zero *] q.vaz)
  dat(state !<(state-zero vaz))
::
++  poke
  |=  [mar=mark vaz=vase]
  ^+  dat
  ?>  ?=(%token-axn mar)
  =/  =axn  !<(axn vaz)
  ?-    -.axn
    :: create a txn locally and send it
      %sire
    =.  ltid  +(ltid)
    =/  src  src.germ.axn
    =/  =txn  
      :+  tim=now.bol
        tid=ltid
      germ.axn
    =/  hash  (shax (jam txn))
    =/  new-cards=(list card)
      ;:  weld
      ::  commit to local scry namespace
      ::  XX after NDN pass it around
      ^-  (list card)
      :~  :*  %pass
              /token/(scot %p src)/(scot %ud ltid)
              %grow
              /txn/(scot %ud ltid)
              [%token-txn txn]
      ==  ==
      ::  validator notification
      =/  cag  [%token-cast !>([src=our.bol tid=ltid hax=hash])]
      ^-  (list card)
      %+  turn  validators.shared
        |=  val=@p
        [%pass /token/(scot %ud ltid)/(scot %p val) %agent [val %token] %poke cag]
      ==
    (emil new-cards)
    ::
    :: receive a remote txn and verify
      %cast
    ::  /token/[src]/txn/[tid]
    =/  seed  `seed`+.axn
    =/  new-cards=(list card)
      :~  :*  %pass
              /token/(scot %p src.seed)/(scot %ud tid.seed)
              %arvo  %a  %keen
              src.seed
              :: this should always be to the first binding
              /g/x/0/token/txn/(scot %ud tid.seed)
      ==  ==
    =.  pend  (~(put in pend) seed)
    (emil new-cards)
    ::
    :: mint a genesis block
      %born
    ?>  =(~ chain)
    =/  =stone
      :*  hght=0
          prev=(shax ~)
          stmp=now.bol
          txns=~
          mint=our.bol
          slsh=%.n
      ==
    =.  chain  ~[[(shax (jam stone)) stone]]
    dat
  ==
::
++  arvo
  |=  [wir=(pole knot) sig=sign-arvo]
  ^+  dat
  ?+    wir  ~|(%bad-wire dat)
      [%token tsrc=@ ttid=@ ~]
    ?+    sig  ~|(%bad-arvo-sign dat)
        [%ames %tune *]
      ::  remote scry request handler
      =/  roar  roar.sig
      ?~  roar  dat
      ::  verify remote scry response is marked %token-txn
      ?>  =(%token-txn p:(need q.dat.u.roar))
      ::  itxn: incoming TXN
      =/  itxn=txn  ;;(txn q:(need q.dat.u.roar))
      =/  =seed  [src=src.itxn tid=tid.itxn hax=(shax (jam itxn))]
      ::  verify itxn matches attested hash from seed
      ?.  (~(has in pend) seed)
        ~|(%bad-hash dat)
      ::  valid TXN, promote to pending for chain
      =.  pent  (~(put in pent) itxn)
      dat
    ==
  ==
--

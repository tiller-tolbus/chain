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
      pend=(set txn-seed)    :: unverified, unauthenticated
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
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
++  on-init
  ^-  (quip card _this)
  ~>  %bout.[0 '%token +on-init']
  `this(shared bootstrap-state)
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
      %submit-txn
    =.  ltid  +(ltid)
    =/  src  src.txn-data.action
    =/  =txn  
      :+  tim=now.bowl
        tid=ltid
      txn-data.action
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
              [%noun txn]
      ==  ==
      ::  validator notification
      =/  cag  [%noun !>([src=our.bowl tid=ltid hax=hash])]
      ^-  (list card)
      %+  turn  ~(tap in validators.shared)
        |=  val=@p
        [%pass /token/(scot %ud ltid)/(scot %p val) %agent [val %token] %poke cag]
      ==
    [new-cards this]
    ::
    ::   receive a remote txn
      %send-txn
    ::  /token/[src]/txn/[tid]
    =/  txn-seed  txn-seed.action
    =/  new-cards=(list card)
      :~  :*  %pass
              /token/(scot %p src.txn-seed)/(scot %ud tid.txn-seed)
              %arvo  %a  %keen
              src.txn-seed
              :: this should always be to the first binding
              /g/x/0/token/txn/(scot %ud tid.txn-seed)
      ==  ==
    =.  pend  (~(put in pend) txn-seed)
    [new-cards this]
    ::
    :: mint a genesis block
      %bootstrap
    ?>  =(~ chain)
    =/  =block-data
      :*  hght=0
          prev=(shax ~)
          stmp=now.bowl
          mint=our.bowl
          slsh=%.n
          txns=~
      ==
    =.  chain  ~[[(shax (jam block-data)) block-data]]
    `this
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
      [%token tsrc=@ ttid=@ ~]
    ?+    sign  ~|(%bad-arvo-sign !!)
        [%ames %tune *]
      ::  remote scry request handler
      =/  roar  roar.sign
      ?~  roar  ~|(%empty-roar !!)
      ::  verify remote scry response is marked %token-txn
      ?>  =(%noun p:(need q.dat.u.roar))
      ::  itxn: incoming TXN
      =/  itxn=txn  ;;(txn q:(need q.dat.u.roar))
      =/  =txn-seed  [src=src.itxn tid=tid.itxn hax=(shax (jam itxn))]
      ::  verify itxn matches attested hash from txn-seed
      ?.  (~(has in pend) txn-seed)
        ~|(%bad-hash !!)
      ::  valid TXN, promote to pending for chain
      =.  pent  (~(put in pent) itxn)
      `this
    ==
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
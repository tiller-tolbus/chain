/-  *pki-store,
    *token
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
      dbug=?             :: safety rails on dev pokes
      ::  dbug default to %.y during early testing
      our-life=@ud
      keys=acru:ames
      =pki-store
      =chain
      pend=(set @)       :: txn queue
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
  ::  subscribe to pki-store updates
      [%pass /token/pki-store %agent [our.bowl %pki-store] %watch /pki-diffs]
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
  ~&  mark
  ^-  (quip card _this)
  ?>  ?=(%token-action mark)
  =/  action  !<(token-action vase)
  ~&  -.action
  ?-  -.action  :: ~|(%bad-mark !!)
    ::
    ::  receive txn from client
      %local-txn
    =.  ltid  +(ltid)
    =/  =txn
      :*  src=our.bowl
          liv=our-life
          tim=now.bowl
          tid=ltid
          txn-data.action
      ==
    =/  msg=@  (sign:as:keys (jam txn))
    ::  alert validators of new txn
    ~&  "checkpoint"
    =/  cards=(list card)
      =/  =cage  [%token-action !>([%remote-txn msg])]
      ^-  (list card)
      %+  turn  ~(tap in validators.shared)
      |=  val=@p
      :*  %pass  /token/remote-txn/(scot %p our.bowl)/(scot %ud tid.txn)
          %agent  [val %token]  %poke  cage
      ==
    [cards this]
    ::
    ::  receive a remote txn
      %remote-txn
    ::  todo: query pki
    ::  currently using our own signature
    ::
    ::  verify signature
    =/  ver  (sure:as:keys msg.action)
    ?~  ver  ~&("failed signature" [~ this])
    ::  verify structure of txn
    =/  des  ((soft txn) (cue u.ver))
    ?~  des  ~&("failed deserialization" [~ this])
    =.  pend  (~(put in pend) msg.action)
    ~&  ["queue updated" pend]
    [~ this]
    ::
    ::  mint genesis block
      %genesis
    ?>  =(~ chain)
    =/  genesis
      %-  jam
      ^-  block
      :*  stmp=now.bowl
          mint=our.bowl
          life=our-life
          hght=0
          prev=(shax ~)
          slsh=%.n
          text=''
          txns=~
      ==
    =/  =hashed-block  [(shax genesis) genesis]
    =/  signed-block
      %-  (soft signed-block)
      (cue (sign:as:keys (jam hashed-block)))
    ?~  signed-block  ~&("failed to deserialize genesis" [~ this])
    [~ this(chain ~[(jam u.signed-block)])]
    ::
      %set-dbug
    [~ this(dbug dbug.action)]
    ::
      %set-shared-state
    ?>  dbug
    [~ this(shared val.action)]
  == 
::
++  on-peek
  |=  pat=path
  ~>  %bout.[0 '%token +on-peek']
  ^-  (unit (unit cage))
  [~ ~]
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ~>  %bout.[0 '%token +on-agent']
  ~&  [wire -.sign]
  ^-  (quip card _this)
  ?+  wire  ~&([%bad-wire wire] !!)
    ::
    ::  %remote transactions
      [%token %remote-txn @ @ ~]
    ?+  -.sign  ~&([%bad-sign -.sign] !!)
        [%poke-ack]
      [~ this]
    ==
    ::
    ::  subscription responses to %pki-store
      [%token %pki-store ~]
    ?+  -.sign  ~&([%bad-sign -.sign] !!)
        ::
        %fact
      ?+  p.cage.sign  ~&([%bad-mark p.cage.sign] !!)
          %pki-snapshot
        =/  new-pki-store  !<(^pki-store q.cage.sign)
        [~ this(pki-store new-pki-store)]
          %pki-diff
        =/  entry  !<(pki-entry q.cage.sign)
        =+  entry
        =/  new-pki-store  (~(put bi pki-store) ship life pass)
        [~ this(pki-store new-pki-store)]
      ==
        ::
        ::  resub to pki-store on kick
        %kick
      :_  this
      :~  :*  %pass  /token/pki-store  %agent
              [our.bowl %pki-store]  %watch
              /pki-diffs
      ==  ==
        ::
        %watch-ack
      [~ this]
    ==
  ==
::
++  on-arvo
  |=  [=wire sign=sign-arvo]
  ~>  %bout.[0 '%token +on-arvo']
  ~&  [wire -.sign -.+.sign]
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
    :-  ~
    %=  this
      our-life  life.sign
      keys  (nol:nu:crub:crypto private-key)
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
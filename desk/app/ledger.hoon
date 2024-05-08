/-  cw=clockwork, lg=ledger, ch=chain, pki=pki-store
/+  default-agent, dbug, *mip
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0  [=history:cw =pki-store:pki]
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
++  on-watch
  |=  =path
  ^-  (quip card _this)
  =^  cards  state
    abet:(watch:cor path)
  [cards this]
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  =^  cards  state
    abet:(agent:cor wire sign)
  [cards this]
 ++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  =^  cards  state
    abet:(poke:cor mark vase)
  [cards this]
++  on-peek   peek:cor
++  on-save  !>(state)
++  on-load
  |=  =vase
  ^-  (quip card _this)
  =^  cards  state
    abet:(load:cor vase)
  [cards this]
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
  =.  cor  watch-pki
  watch-blocs
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
      [%x %balances ~]  ``balances+!>((balance-from-history history ~))
  ==
++  poke
  |=  [=mark =vase]
  ^+  cor
  cor
  ::  ?+  mark  ~|(bad-poke+mark !!)
  ::  ==
++  watch
  |=  =(pole knot)
  ^+  cor
  ?+  pole  ~|(bad-watch-path+`path`pole !!)
      [%balances ~]
    ?>  =(src.bowl our.bowl)
    (give %fact ~ balances+!>(balances))
  ==
++  agent
  |=  [=(pole knot) =sign:agent:gall]
  ^+  cor
  ?+  pole  ~|(bad-agent-wire+pole !!)
      [%blocs ~]
    ?+  -.sign  !!
        %kick  watch-blocs
        %watch-ack
      ?~  p.sign
        cor
      ((slog leaf+"failed subscription to blocs" u.p.sign) cor)
        %fact
      (take-update !<(bloc-update:cw q.cage.sign))
    ==
      [%pki-diffs ~]
    ?+  -.sign  !!
        %kick  watch-pki
        %watch-ack
      ?~  p.sign
        cor
      ((slog leaf+"failed subscription to pki" u.p.sign) cor)
        %fact
      (take-pki !<(pki-store:pki q.cage.sign))
    ==
  ==
++  balances
  |=  =internal-balances:lg
  %-  ~(urn by internal-balances)
  |=  [k=@ v=[balance=@ud nonce=@ud faucet=?]]
  balance.v
++  take-update
  |=  update=bloc-update:cw
  ^+  cor
    ?-  -.update
      %reset
    take-reset
      %blocs
    =.  history  (uni:hon:cw history history.update)
    (give %fact ~[/balances] balances+!>((balance-from-history history history.update)))
  ==
++  take-reset
  ^+  cor
  =.  history  ~
  cor
++  balance-from-history
  |=  [old=history:cw new=history:cw]
  ^-  balances:lg
  =/  his=(list [@ud voted-bloc:cw])  (tap:hon:cw (uni:hon:cw old new))
  =/  =internal-balances:lg  ~
  |-
  ~+
  ?~  his  (balances internal-balances)
  %=  $
      his  t.his
      internal-balances
    =-  +.-
    ~&  txns.bloc.i.his
    %^  spin  txns.bloc.i.his
      internal-balances
    |=  [txn=* br=(map addr:ch [balance=@ud nonce=@ud faucet=?])]
    ^-  [* (map @ux [@ud @ud ?])]
    ::  is it structured like a transaction?
    ~&  >  'is it structured like a transaction?'
    ~&  >>  -.txn
    ~&  >>  +.txn
    ?.  ?=(txn-signed:ch txn)  [txn br]
    ::  is it signed correctly?
    ~&  >  'is it signed correctly?'
    =/  keys  (com:nu:crub:crypto who.txn)
    ?.  (safe:as:keys -.txn (jam +.txn))  [txn br]
    ::  is the nonce sequential?
    ~&  >  'is the nonce sequential?'
    =/  prior  (prior-balance br who.txn)
    ?.  =(nonce.prior nonce.txn)  [txn br]
    ::  is it for %ledger instead of another app?
    ~&  >  'is it for %ledger instead of another app?'
    ?.  ?=(txn-ledger:lg txn)
      [txn (~(put by br) who.txn [balance.prior +(nonce.prior) faucet.prior])]
    =/  cmd=ledger-cmd:lg  cmd.txn
    ?-  cmd
        [%send target=@ amount=@]
      ::  do they have the tokens they want to send?
      ~&  >  'do they have the tokens they want to send?'
      ?:  (gth amount.cmd balance.prior)  [txn br]
      =/  deducted
        %+  ~(put by br)  who.txn
        [(sub balance.prior amount.cmd) +(nonce.prior) faucet.prior]
      =/  target-prior  (~(gut by br) target.cmd [balance=0 nonce=0 faucet=%.n])
      :-  txn
      %+  ~(put by deducted)  target.cmd
      [(add balance.target-prior amount.cmd) nonce.target-prior faucet.target-prior]
    ==
  ==
++  take-pki
  |=  p=pki-store:pki
  ^+  cor
  cor(pki-store p)
++  watch-pki
  (emit %pass /pki-diffs %agent [our.bowl %pki-store] %watch /pki-diffs)
++  watch-blocs
  (emit %pass /blocs %agent [our.bowl %chain] %watch /blocs)
++  node-keys  (turn nodes:cw latest-key)
++  latest-key
  |=  =ship
  ^-  pass
  =/  top  (~(rep in (~(key bi pki-store) ship)) max)
  =/  key  (~(get bi pki-store) ship top)
  ?~  key  !!
  u.key
++  prior-balance
  |=  [ib=internal-balances:lg =addr:ch]
  ?~  (find ~[addr] node-keys)
    (~(gut by ib) addr [balance=0 nonce=0 faucet=%.n])
  (~(gut by ib) addr [balance=(bex 64) nonce=0 faucet=%.y])
--

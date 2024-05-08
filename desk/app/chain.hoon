/-  cw=clockwork, ch=chain, lg=ledger, pki=pki-store
/+  default-agent, dbug, *mip
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0  [=history:cw =pki-store:pki =wallets:ch =sent-txns:ch]
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
++  on-save  !>(state)
++  on-load
  |=  =vase
  ^-  (quip card _this)
  =^  cards  state
    abet:(load:cor vase)
  [cards this]
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  =^  cards  state
    abet:(agent:cor wire sign)
  [cards this]
++  on-watch
  |=  =path
  ^-  (quip card _this)
  =^  cards  state
    abet:(watch:cor path)
  [cards this]
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  =^  cards  state
    abet:(poke:cor mark vase)
  [cards this]
++  on-peek   peek:cor
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
      [%x %wallets ~]
    ``wallets+!>(~(key by wallets))
      [%x %balances ~]
    ``balances+!>(.^(balances:lg %gx /(scot %p our.bowl)/ledger/(scot %da now.bowl)/balances/noun))
      [%x %transactions addr=@ ~]
    =-  ``transactions+!>(~(tap in -))
    ^-  (set txn-signed:ch)
    =/  nonces  (~(key bi sent-txns) addr.pole)
    %-  ~(run in nonces)
    |=  nonce=@ud
    (~(got bi sent-txns) addr.pole nonce)
      [%x %transactions addr=@ %pending ~]
    =/  wallet-txns
      =-  ~(tap in -)
      ^-  (set txn-signed:ch)
      =/  nonces  (~(key bi sent-txns) addr.pole)
      %-  ~(run in nonces)
      |=  nonce=@ud
      (~(got bi sent-txns) addr.pole nonce)
    =/  com  (committed-nonce addr.pole)
    =-  ``transactions+!>(-)
    %+  skim  wallet-txns
    |=  =txn-signed:ch
    (gte nonce.txn-signed com)
  ==
++  watch
  |=  =(pole knot)
  ^+  cor
  ?+  pole  ~|(bad-watch-path+`path`pole !!)
      [%blocs ~]
    ?>  =(src.bowl our.bowl)
    (give %fact ~ bloc-update+!>([%blocs history]))
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
      [%ask-faucet ~]
    ?+  -.sign  !!
        %poke-ack
      ?~  p.sign
        cor
      ((slog leaf+"failed faucet" u.p.sign) cor)
    ==
  ==
++  poke
  |=  [=mark =vase]
  ^+  cor
  ?+  mark  ~|(bad-poke+mark !!)
      %new-wallet
    ?>  =(src.bowl our.bowl)
    =+  !<(name=cord vase)
    ?<  (~(has by wallets) name)
    =/  keys  (pit:nu:crub:crypto 512 eny.bowl)
    =.  wallets  (~(put by wallets) name [pub:ex:keys sec:ex:keys])
    cor
      %send-tokens
    ::  convenience poke for %ledger %send transactions
    ?>  =(src.bowl our.bowl)
    =+  !<([name=cord target=addr:ch amount=@ud] vase)
    =/  =wallet:ch  (~(got by wallets) name)
    =/  keys  (nol:nu:crub:crypto sec.wallet)
    =/  =txn-unsigned:ch
      :*  pub.wallet
          (nonce pub.wallet)
          [%ledger 0 [%send target amount]]
      ==
    =/  =txn-signed:ch
      [(sigh:as:keys (jam txn-unsigned)) txn-unsigned]
    =.  sent-txns  (~(put bi sent-txns) pub.wallet (nonce pub.wallet) txn-signed)
    %-  emil
    %+  turn  validators
    |=  who=ship
    [%pass /send-txn %agent [who %clockwork] %poke noun+!>([%txn txn-signed])]
      %send-txn
    ?>  =(src.bowl our.bowl)
    =+  !<([name=cord =txn-stub:ch] vase)
    =/  =wallet:ch  (~(got by wallets) name)
    =/  keys  (nol:nu:crub:crypto sec.wallet)
    =/  =txn-unsigned:ch
      :*  pub.wallet
          (nonce pub.wallet)
          txn-stub
      ==
    =/  =txn-signed:ch
      [(sigh:as:keys (jam txn-unsigned)) txn-unsigned]
    =.  sent-txns  (~(put bi sent-txns) pub.wallet (nonce pub.wallet) txn-signed)
    %-  emil
    %+  turn  validators
    |=  who=ship
    [%pass /send-txn %agent [who %clockwork] %poke noun+!>([%txn txn-signed])]
      %ask-faucet
    ?>  =(src.bowl our.bowl)
    =+  !<(name=cord vase)
    =/  =wallet:ch  (~(got by wallets) name)
    (emit %pass /ask-faucet %agent [primary:cw %clockwork] %poke noun+!>([%faucet pub.wallet]))
  ==
++  take-update
  |=  update=bloc-update:cw
  ^+  cor
  ?-  -.update
      %reset
    take-reset
      %blocs
    ?.  (all:hon:cw history.update verify-bloc)  cor
    =.  history  (uni:hon:cw history history.update)
    (give %fact ~[/blocs] bloc-update+!>([%blocs history.update]))
  ==
++  take-reset
  ^+  cor
  ?>  =(src.bowl primary:cw)
  =.  history  ~
  =.  sent-txns  ~
  (give %fact ~[/blocs] bloc-update+!>([%reset ~]))
++  verify-bloc
  |=  [height=@ud =bloc:cw =quorum:cw]
  ^-  ?
  =-  (gte (lent -) needed-validators)
  %+  skim  ~(tap in quorum)
  |=  =signature:cw
  ?~  (find ~[q.signature] nodes:cw)  %.n
  =/  vote  [bloc height.bloc round.bloc %2]
  =/  key  (~(get bi pki-store) q.signature r.signature)
  ?~  key  %.n
  =/  keys  (com:nu:crub:crypto u.key)
  (safe:as:keys p.signature (jam vote))
++  take-pki
  |=  p=pki-store:pki
  ^+  cor
  cor(pki-store p)
++  watch-pki
  (emit %pass /pki-diffs %agent [our.bowl %pki-store] %watch /pki-diffs)
++  watch-blocs
  %-  emil
  %+  turn  validators
  |=  who=ship
  [%pass /blocs %agent [who %clockwork] %watch /blocs]
++  validators
  ^-  (list ship)
  ~+
  ?^  (find ~[our.bowl] nodes:cw)
    ~[our.bowl primary:cw]
  ::  seed with @p to broadcast txns to the same validators every time
  ::  otherwise it may be possible to send nonces out of order
  =/  rng  ~(. og our.bowl)
  =/  vals=(list ship)  ~[primary:cw]
  =/  nods=(list ship)  nodes:cw
  |-
  ?:  (gte (lent vals) needed-validators)
    vals
  =^  next  rng  (rads:rng (lent nods))
  $(vals [(snag next nods) vals], nods (oust [next 1] nods))
++  needed-validators  +((div (lent nodes:cw) 3))
++  latest-key
  |=  =ship
  ^-  pass
  =/  top  (~(rep in (~(key bi pki-store) ship)) max)
  =/  key  (~(get bi pki-store) ship top)
  ?~  key  !!
  u.key
++  nonce
  |=  =addr:ch
  =/  nonces  (~(key bi sent-txns) addr)
  ?~  nonces  0
  (~(rep in `(set @ud)`nonces) max)
++  committed-nonce
  |=  =addr:ch
  ^-  @ud
  =/  next  0
  ~+
  =/  his=(list [@ud voted-bloc:cw])  (tap:hon:cw history)
  |-
  ?~  his  next
  %=  $
      his  t.his
      next
    =-  +.-
    %^  spin  txns.bloc.i.his
      next
    |=  [txn=* n=@ud]
    ^-  [* @ud]
    ::  is it structured like a transaction?
    ?.  ?=(txn-signed:ch txn)  [txn next]
    ::  is it from this wallet?
    ?.  =(who.txn addr)  [txn next]
    ::  is it signed correctly?
    =/  keys  (com:nu:crub:crypto addr)
    ?.  (safe:as:keys -.txn (jam +.txn))  [txn next]
    ::  is the nonce sequential?
    ?.  =(nonce.txn next)  [txn next]
    [txn +(next)]
  ==
--

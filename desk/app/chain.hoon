/-  cw=clockwork, ch=chain, pki=pki-store
/+  default-agent, dbug, *mip
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0  [=history:cw =pki-store:pki =wallets:ch]
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
  watch-blocks
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
      [%wallets ~]  ``wallets+!>(~(key by wallets))
  ==
++  watch
  |=  =(pole knot)
  ^+  cor
  ?+  pole  ~|(bad-watch-path+`path`pole !!)
      [%blocks ~]
    ?>  =(src.bowl our.bowl)
    (give %fact ~ history+!>(history))
  ==
++  agent
  |=  [=(pole knot) =sign:agent:gall]
  ^+  cor
  ?+  pole  ~|(bad-agent-wire+pole !!)
      [%blocks ~]
    ?+  -.sign  !!
        %kick  watch-blocks
        %watch-ack
      ?~  p.sign
        cor
      ((slog leaf+"failed subscription to blocks" u.p.sign) cor)
        %fact
      (take-blocks !<(history:cw q.cage.sign))
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
    %-  emil
    %+  turn  validators
    |=  who=ship
    [%pass /send-txn %agent [who %clockwork] %poke noun+!>([%txn txn-signed])]
  ==
++  take-blocks
  |=  update=history:cw
  ^+  cor
  |-
  ?~  update  cor
  ?.  (verify-block i.update)  $(update t.update)
  ?:  (gth height.i.update (lent history))  cor
  ?:  =(height.i.update (lent history))
    =.  cor  (give %fact ~[/blocks] history+!>(history))
    cor(history (weld history update))
  $(update t.update)
++  verify-block
  |=  =block:cw
  ^-  ?
  =-  (gte (lent -) needed-validators)
  %+  skim  ~(tap in last.block)
  |=  =signature:cw
  ?~  (find ~[q.signature] nodes:cw)  %.n
  =/  vote  [block height.block round.block %2]
  =/  key  (~(get bi pki-store) q.signature r.signature)
  ?~  key  %.n
  =/  keys  (com:nu:crub:crypto u.key)
  ?~  (safe:as:keys p.signature (jam vote))  %.n
  %.y
++  take-pki
  |=  p=pki-store:pki
  cor(pki-store p)
++  watch-blocks
  %-  emil
  %+  turn  validators
  |=  who=ship
  [%pass /blocks %agent [who %clockwork] %watch /blocks]
++  watch-pki
  (emit %pass /pki-diffs %agent [our.bowl %pki-store] %watch /pki-diffs)
++  validators
  ^-  (list ship)
  ?^  (find ~[our.bowl] nodes:cw)
    ~[our.bowl]
  =/  rng  ~(. og eny.bowl)
  =/  vals=(list ship)  ~
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
  ^-  @ud
  =/  next  0
  ~+
  |-
  ?~  history  next
  %=  $
      history  t.history
      next
    =-  +.-
    %^  spin  txns.i.history
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

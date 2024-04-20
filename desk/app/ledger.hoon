/-  cw=clockwork, lg=ledger
/+  default-agent, dbug
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0  ~
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
    cor   ~(. +> bowl)
++  on-init   [~ this]
++  on-peek   peek:cor
++  on-save   on-save:def
++  on-load   on-load:def
++  on-poke   on-poke:def
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
|_  =bowl:gall
++  peek
  |=  =(pole knot)
  ^-  (unit (unit cage))
  ?>  ?=(^ pole)
  ?+  pole  [~ ~]
      [%x %v0 %balances ~]
    ``balances+!>(balances)
  ==
++  balances
  =/  =history:cw
    .^(history:cw %gx /(scot %p our.bowl)/chain/(scot %da now.bowl)/v0/history/noun)
  =/  running  *(map addr:lg [balance=@ud nonce=@ud faucet=?])
  |-
  ?~  history
    %-  ~(urn by running)
    |=  [k=@ v=[balance=@ud nonce=@ud faucet=?]]
    balance.v
  %=  $
      history  t.history
      running
    =-  +.-
    %^  spin  txns.i.history
      running
    |=  [txn=* br=(map addr:lg [balance=@ud nonce=@ud faucet=?])]
    ^-  [* (map @ux [@ud @ud ?])]
    ::  TODO verify signature
    ?.  ?=(txn-signed:lg txn)  [txn br]
    =/  prior  (~(gut by br) who.txn [balance=0 nonce=0 faucet=%.n])
    ?.  =(nonce.prior nonce.txn)  [txn br]
    ?-  -.cmd.txn
        %send
      ?:  (gth amount.cmd.txn balance.prior)  [txn br]
      =/  deducted
        %+  ~(put by br)  who.txn
        [(sub balance.prior amount.cmd.txn) +(nonce.prior) faucet.prior]
      =/  target-prior  (~(gut by br) target.cmd.txn [balance=0 nonce=0 faucet=%.n])
      :-  txn
      %+  ~(put by deducted)  target.cmd.txn
      [(add balance.target-prior amount.cmd.txn) nonce.target-prior faucet.target-prior]
        %faucet
      ?:  faucet.prior  [txn br]
      [txn (~(put by br) who.txn [(add balance.prior (bex 16)) +(nonce.prior) %.y])]
    ==
  ==
--

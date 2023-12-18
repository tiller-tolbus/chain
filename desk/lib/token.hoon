/-  *token
|%
::  wrapping/unwrapping
::
++  wrap-block
  |=  [keys=acru:ames =block]
  ^-  raw-signed-block
  =/  =raw-block  (jam block)
  =/  =hashed-block  [(shax raw-block) raw-block]
  %-  sign:as:keys  (jam hashed-block)
++  unwrap-block
  |=  raw-signed-block=@
  ^-  block
  =/  =signed-block  ;;([@ @] (cue raw-signed-block))
  =/  =raw-hashed-block  +.signed-block
  =/  =hashed-block  ;;([@ @] (cue raw-hashed-block))
  =/  =raw-block  +.hashed-block
  =/  =block  ;;(block (cue raw-block))
  block
++  unwrap-block-verbose
  |=  raw-signed-block=@
  ^-  block
  =/  signed-block  ((soft [@ @]) (cue raw-signed-block))
  ?~  signed-block  ~&(["raw-signed-block invalid" raw-signed-block] !!)
  =/  =raw-hashed-block  +.u.signed-block
  =/  hashed-block  ((soft [@ @]) (cue raw-hashed-block))
  ?~  hashed-block  ~&(["raw-hashed-block invalid" raw-hashed-block] !!)
  =/  =raw-block  +.u.hashed-block
  =/  block  ((soft block) (cue raw-block))
  ?~  block  ~&(["raw-block invalid" raw-block] !!)
  u.block
::  
++  process-txn
  |=  [=txn shared=shared-state pool=@udtoken]
  ^-  txn-result
  =/  src  src.txn
  ?:  ?=(?(%pawn %earl) (clan:title src))
    [%bad-rank src (clan:title src)]
  =/  bid  bid.txn
  =/  ubal  (~(get by ledger.shared) src)
  ?~  ubal  [%src-no-bal src]
  =/  bal  u.ubal
  ?:  (gte bid bal)
    [%bid-gte-bal src bid bal]
  =.  bal  (sub bal bid)
  =.  pool  (add pool bid)
  ?-  -.act.txn
      ::
      %spend
    =/  des  des.act.txn
    ?:  ?=(?(%pawn %earl) (clan:title des))
      [%bad-rank-des src des (clan:title des)]
    =/  amt  amt.act.txn
    ?:  (gte amt bal)
      [%amt-gte-bal src amt bal]
    =/  bal  (sub bal amt)
    =.  ledger.shared  (~(put by ledger.shared) des amt)
    =.  ledger.shared  (~(put by ledger.shared) src bal)
    [%success shared pool]
      ::
      %join
    ?:  ?=(%king (clan:title src))
      [%bad-rank-val src (clan:title src)]
    ?:  (~(has in validators.shared) src)
      [%already-val src]
    =.  validators.shared  (~(put in validators.shared) src)
    [%success shared pool]
      ::
      %leave
    ?.  (~(has in validators.shared) src)
      [%not-val src]
    =.  validators.shared  (~(del in validators.shared) src)
    [%success shared pool]
    ::
      %claim
    ?.  (~(has in claimants.shared) src)
      [%no-claim src]
    =.  claimants.shared  (~(del in claimants.shared) src)
    =/  air  (mul (bex 16) yarvin-scale)
    ?.  (~(has by ledger.shared) src)
      =.  ledger.shared  (~(put by ledger.shared) src air)
      [%success shared pool]
    =/  bal  (~(got by ledger.shared) src)
    =.  ledger.shared  (~(put by ledger.shared) src (add bal air))
    [%success shared pool]
    ::
      %null
    [%success shared pool]
  ==
--
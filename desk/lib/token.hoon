/-  *token
|%
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
--
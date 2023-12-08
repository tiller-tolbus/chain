|%
::
::    Part 1: Essential Blockchain Types
::    
+$  chain  (list block)
+$  block  [sign=@uvH hash=@uvH block-data]
::  block-data: data fields hashed at the head of the block
+$  block-data
  $:  hght=@ud             ::  block height
      prev=@uvH            ::  parent block hash
      stmp=@da             ::  timestamp (deterministic in case of slash)
      mint=@p              ::  minter address
      slsh=?               ::  whether to slash mint
      txns=(list txn)      ::  all transactions (size enforced by protocol)
  ==
::  shared-state: total state derivable from chain
+$  shared-state
  $:  ledger=(map @p @udtoken)  ::  network-wide $TOKEN balance
      validators=(set @p)      ::  eligible validators for election
      blacklist=(map @p @da)    ::  slashed validators in timeout
  ==
::  txn: verifiable modification of shared-state
+$  txn
  $:  sig=@uvH             ::  signature
      tim=@da              ::  timestamp
      tid=@ud              ::  transaction ID per-ship (nonce)
      txn-data
  ==
::  txn-data: user-entered data to process into full txn
+$  txn-data
  $:  src=@p               ::  who is transacting
      bid=@udtoken         ::  claimable by validator for inclusion in a block
      txt=@t               ::  arbitrary metadata (max size enforced by protocol)
      act=chain-action     ::  modification of shared-state
  ==
::  chain-action: modification of shared-state
+$  chain-action
  $%  [%deposit des=@p amt=@udtoken bid=@udtoken]
      [%join ~]
      [%leave ~]
  ==
::  
::  Part 2: Protocol Configuration
::
::  max number of transactions per block
++  max-txns  `@ud`1.024
::  blacklist duration
++  decay-rate  `@dr`~d7
::  num yarvs per token
++  token-scale  `@ud`(pow 2 32)
::  max character length of txt field in txn
++  max-txt-chars  `@ud`256
::  initial shared-state, including airdrop to stars
++  bootstrap-state
  ^-  shared-state  :+  
  ::  ledger: initial airdrop to stars
  ^-  (map @p @udtoken)  
  %-  molt
  %+  turn  (gulf ~marzod ~fipfes)
    |=  p=@
    ^-  [@p @udtoken]
    [p (mul (bex 16) token-scale)]
  ::  validators: genesis block author
  ^-  (set @p)
  (silt ~[~woldeg])  
  ::  blacklist: stars in time-out (initially empty)
  ^-  (map @p @da)  ~
::
::  Part 3: Implementation-Specific Types
::
::  txn-seed: attestation of a pending txn
+$  txn-seed  [src=@p tid=@ud hax=@uvH]
::
::  Part 4: Agent Actions
+$  token-action
  $%  
    [%bootstrap ~]          :: mint genesis block
    [%submit-txn =txn-data]      :: send txn to agent from client
    [%send-txn =txn-seed]        :: send txn to validators from agent
  ==
--

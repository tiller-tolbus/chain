|%
::
::    Part 1: Essential Blockchain Types
::    
+$  chain  (list signed-block=@)
::
::  every crypto step (sign or hash) is followed by a
::  serialization (jam). atoms are given faces indicating
::  what they should deserialize (cue) to. 
::
::  signature on hash and jammed hashed block
+$  signed-block  [=life sign=@ hashed-block=@]
::  hash and jammed block
+$  hashed-block  [hash=@uvH block=@]
::  block: data fields comprising a block
+$  block
  $:  stmp=@da                 ::  timestamp (deterministic in case of slash)
      mint=@p                  ::  minter address
      life=@ud
      hght=@ud                 ::  block height
      prev=@uvH                ::  parent block hash
      slsh=?                   ::  whether to slash mint
      text=@t                  ::  256-char arbitrary metadata
      txns=(list @)            ::  all transactions
  ==
::
::  signed-txn: verifiable modification of shared-state
+$  signed-txn
  $:  sig=@            ::  signature
      txn=@
  ==
::  txn: txn data that gets signed
+$  txn
  $:  src=@p               ::  who is transacting
      liv=@ud              ::  revision number of src
      tim=@da              ::  timestamp
      tid=@ud              ::  transaction ID per-ship (nonce)
      txn-data
  ==
::  txn-data: user-entered data to process into full txn
+$  txn-data
  $:  bid=@udtoken         ::  claimable by validator for inclusion in a block
      txt=@t               ::  arbitrary metadata (max size enforced by protocol)
      act=chain-action     ::  modification of shared-state
  ==
::  chain-action: modification of shared-state
+$  chain-action
  $%  [%spend des=@p amt=@udtoken bid=@udtoken]  ::  spend money
      [%join ~]                                  ::  become validator
      [%leave ~]                                 ::  stop validating
  ==
::  shared-state: total state derivable from chain
+$  shared-state
  $:  ledger=(map @p @udtoken)  ::  network-wide $TOKEN balance
      validators=(set @p)      ::  eligible validators for election
      blacklist=(map @p @ud)    ::  slashed validators in timeout
  ==

::  
::  Part 2: Protocol Configuration
::
::  max number of transactions per block
++  max-txns  `@ud`1.024
::  blacklist duration (in blocks)
++  decay-rate  `@ud`1.024
::  num yarvins per token
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
  ^-  (map @p @ud)  ~
::
::  Part 3: Implementation-Specific Types
::
++  bootstrap-fakezod
  ^-  shared-state  :+  
  ^-  (map @p @udtoken)  
  %-  molt
  %+  turn  (gulf ~zod ~fes)
    |=  p=@
    ^-  [@p @udtoken]
    [p (mul (bex 16) token-scale)]
  ^-  (set @p)
  (silt ~[~zod])  
  ^-  (map @p @ud)  ~
::
::  Part 4: Agent Actions
+$  token-action
  $%  
    ::  protocol actions
    [%local-txn =txn-data]           :: send txn to agent from client
    [%remote-txn msg=@]        :: send txn to validators from agent
    [%genesis ~]                     :: mint genesis block
    ::  debug actions
    [%set-dbug dbug=?]                   :: toggle dbug flag
    [%set-shared-state val=shared-state] :: force shared state to input
  ==
--

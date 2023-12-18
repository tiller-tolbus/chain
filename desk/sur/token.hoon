|%
::
::    Part 1: Essential Blockchain Types
::    
+$  chain  (list raw-signed-block=@)
::
::  every crypto step (sign or hash) is followed by a
::  serialization (jam). atoms are given faces indicating
::  what they should deserialize (cue) to. 
::
::  jammed signed block
+$  raw-signed-block  @
::  signature on hash and jammed hashed block
+$  signed-block  [sign=@ raw-hashed-block=@]
::  jammed hashed block
+$  raw-hashed-block  @
::  hash and jammed block
+$  hashed-block  [hash=@uvH raw-block=@]
::  jammed block
+$  raw-block  @
::  block: data fields comprising a block
+$  block
  $:  stmp=@da                 ::  timestamp (deterministic in case of slash)
      mint=@p                  ::  minter address
      life=@ud
      hght=@ud                 ::  block height
      prev=@uvH                ::  parent block hash
      slsh=?                   ::  whether to slash mint
      text=@t                  ::  256-char arbitrary metadata
      txns=(list raw-signed-txn)            ::  all transactions
  ==
::
::  jammed signed-txn
+$  raw-signed-txn  @
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
  $%  [%spend des=@p amt=@udtoken]  ::  spend money
      [%join ~]                     ::  become validator
      [%leave ~]                    ::  stop validating
      [%claim ~]                    ::  claim airdrop tokens
      [%null ~]                     ::  do nothing
  ==
::  txn-result: result of applying txn
+$  txn-result
  $%  [%success =shared-state pool=@udtoken]
      [%bad-rank src=@p =rank:title]
      [%bad-rank-des src=@p des=@p =rank:title]
      [%bad-rank-val src=@p =rank:title]
      [%src-no-bal src=@p]  
      [%bid-gte-bal src=@p bid=@udtoken bal=@udtoken]
      [%amt-gte-bal src=@p amt=@udtoken bal=@udtoken]
      [%already-val src=@p]
      [%not-val src=@p]
      [%no-claim src=@p]
  ==
::  shared-state: total state derivable from chain
+$  shared-state
  $:  ledger=(map @p @udtoken)  ::  network-wide $TOKEN balance
      claimants=(set @p)       ::  validators that can claim tokens
      validators=(set @p)      ::  eligible validators for election
      blacklist=(map @p @ud)    ::  slashed validators in timeout
  ==

::  
::  Part 2: Protocol Configuration
::
++  block-time  `@dr`~m10
::  max number of transactions per block
++  max-txns  `@ud`1.024
::  blacklist duration (in blocks)
++  decay-rate  `@ud`1.024
::  num yarvins per token
++  yarvin-scale  `@ud`(pow 2 32)
::  max character length of txt field in txn
++  max-txt-chars  `@ud`256
::  initial shared-state, including airdrop to stars
:: ++  bootstrap-state
::   ^-  shared-state  :+  
::   ::  ledger: initial airdrop to stars
::   ^-  (map @p @udtoken)  
::   %-  molt
::   %+  turn  (gulf ~marzod ~fipfes)
::     |=  p=@
::     ^-  [@p @udtoken]
::     [p (mul (bex 16) yarvin-scale)]
::   ::  validators: genesis block author
::   ^-  (set @p)
::   (silt ~[~woldeg])  
::   ::  blacklist: stars in time-out (initially empty)
::   ^-  (map @p @ud)  ~
::
::  Part 3: Implementation-Specific Types
::
:: ++  bootstrap-fakezod
::   ^-  shared-state  :+  
::   ^-  (map @p @udtoken)  
::   %-  molt
::   %+  turn  (gulf ~zod ~fes)
::     |=  p=@
::     ^-  [@p @udtoken]
::     [p (mul (bex 16) yarvin-scale)]
::   ^-  (set @p)
::   (silt ~[~zod])  
::   ^-  (map @p @ud)  ~
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

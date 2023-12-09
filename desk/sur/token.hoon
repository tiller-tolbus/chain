|%
::
::    Part 1: Essential Blockchain Types
::    
+$  chain  (list block)
+$  block  [sign=@uvH hash=@uvH block-data]
::  block-data: data fields hashed at the head of the block
+$  block-data
  $:  stmp=@da             ::  timestamp (deterministic in case of slash)
      mint=@p              ::  minter address
      hght=@ud             ::  block height
      prev=@uvH            ::  parent block hash
      slsh=?               ::  whether to slash mint
      text=@t              ::  256-char arbitrary metadata
      txns=(list txn)      ::  all transactions (size enforced by protocol)
  ==
::  shared-state: total state derivable from chain
+$  shared-state
  $:  ledger=(map @p @udtoken)  ::  network-wide $TOKEN balance
      validators=(set @p)      ::  eligible validators for election
      blacklist=(map @p @ud)    ::  slashed validators in timeout
  ==
::  txn: verifiable modification of shared-state
+$  txn
  $:  sig=@uvH             ::  signature
      txn-data 
  ==
::  txn-data: txn data that gets signed
+$  txn-data
  $:  tim=@da              ::  timestamp
      tid=@ud              ::  transaction ID per-ship (nonce)
      txn-data-user
  ==
::  txn-data-user: user-entered data to process into full txn
+$  txn-data-user
  $:  src=@p               ::  who is transacting
      bid=@udtoken         ::  claimable by validator for inclusion in a block
      txt=@t               ::  arbitrary metadata (max size enforced by protocol)
      act=chain-action     ::  modification of shared-state
  ==
::  chain-action: modification of shared-state
+$  chain-action
  $%  [%spend des=@p amt=@udtoken bid=@udtoken]  ::  spend money
      [%join ~]                                  ::  become validator
      [%leave ~]                                 ::  stop validating
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
::  Nothing here yet
::
::  Part 4: Agent Actions
+$  token-action
  $%  
    ::  protocol actions
    [%local-txn =txn-data-user]      :: send txn to agent from client
    [%remote-txn =txn]               :: send txn to validators from agent
    [%genesis ~]                     :: mint genesis block
    ::  debug actions
    [%set-dbug dbug=?]                   :: toggle dbug flag
    [%set-shared-state val=shared-state] :: force shared state to input
  ==
--

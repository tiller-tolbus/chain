  ::  /sur/frontier
::::
::
|%
::  Types
+$  who  @p
+$  what  *
+$  signature  [p=@uvH q=ship r=life]
+$  tx
  $:  =who
      =what
      when=@da
  ==
+$  hash  @uvJ
+$  container  [parent=hash =tx score=@ud]
+$  dag   (map hash container)
::
::  Actions
+$  action
  $%  [%poll =hash]  :: poll for txs that may be children of hash
      :: [%deal ]  :: transaction over $token
      [%mint ~]  :: genesis
  ==
::
+$  answer
  $%  [%vote txs=(set tx)]  :: response to %poll
      :: [%moot =tx]           :: communication of tx
  ==
::
++  validators  ^~(`(list @p)`(gulf 0 10))
++  tx-limit  ^~((bex 10))
::  https://docs.avax.network/learn/avalanche/avalanche-consensus#snowball
::  simple majority (in final implementation, 14)
++  alpha  2
::  decision threshold (in final implemenation, 20)
++  beta   5
::  number of validators to sample (same as beta in final)
++  k      3
++  n      ^~((lent validators))
           ::  ^~((sub (bex 16) (bex 8)))
::  liveness criterion for this network?  ~60%
::  in exchange for being slower than the network, a node can arbitrarily approach absolute certainty of any TX
--

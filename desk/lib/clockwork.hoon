/-  *clockwork
|%
++  vote-store
  |%
  ++  filter-valid
  |=  =vote-store
  ^-  (list ^qc)  ::  there should only be one but w/e
  ~&  checking-qcs=[stage round height]
  %+  skim  ~(tap by vote-store)
  |=  i=^qc  ^-  ?
  :: ~&  >  qc=[stage.i round.i height.i ~(wyt in +.i)]
  ?&  %+  gte  ~(wyt in +.i)  (sm (lent nodes))
      .=(height height.i)
      .=(round round.i)
      .=(stage stage.i)
  ==
  ++  filter-stage
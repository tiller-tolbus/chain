#   `%token`

%pki-store
- %token subscribes to %pki-store
- roundtrip block/txn signatures

- TX structure
- TX collector
- TX validator
- etc.


- [ ] pending TXN tracking
- [ ] kelvin-versioning types on Urbit?
- gates for signing txns, signing/hashing blocks

questions:
- assert on path resolution?
- case?

caveats:
- performance
- block length likely quite long at first


scry maximalist route:
- consensus on urbit but you may not have direct route to node
- relay signature?  current ames/remote scry cannot do, but NDN can
- proof-of-authority, slow blockchain as a result
- scry the path to validate the TXN
  - (thus the kernel has already validated the TXN when you scry successfully)
  - question:  what happens to bound scry values after breach?
  - do we need to gossip/mirror these?

```hoon
:token &token-axn [%sire germ=[src=~zod met=[%put des=~tiller-tolbus amt=100 bid=1]]]
.^((list path) %gt /=token=//token/txn)

```

New:
* Create %clockstep
* Rip out arms into lib
* Write tests
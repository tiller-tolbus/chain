`%token` is an Urbit application for sharing a transaction ledger of a fungible digital token over a Byzantine fault-tolerant peer to peer network. Its basic state is a `ledger=(map @p @ud)`, where the `@p` represents an Urbit ID, and thereby a single account in the ledger, and the `@ud` represents an account balance of a fungible asset `$TOKEN`. Global consensus on the state of this `ledger` is enforced by a simplistic Proof of Identity consensus protocol leveraging the scarcity of Urbit Stars. 

In other words, `%token` is an Urbit-native Proof of Identity blockchain that implements a cryptocurrency `$TOKEN`. 

The `%token` blockchain accepts three kinds of transactions: `%deposit`, `%stake`, and `%unstake`.

```hoon
+$  txn
  $%
    %deposit
      $:
        src=@p
        des=@p
        amt=@ud
        txt=@t
        bid=@ud
        sig=@uw
      ==
    %stake  [src=@p sig=@uw]
    %unstake  [src=@p sig=@uw]
  ==
```

These transactions will become events in a log that can be used to deterministically recreate the shared state of the network. 

```hoon
+$  shared-state
  $:
    ledger=(map @p @ud)
    validators=(list @p)
    blacklist=(map @p @da)
  ==
```

In other words, a blockchain is being constructed so that the network of `%token` users may agree on three things: the account balance of every `@p` on the ledger, the set of `@p`s that are authorized to validate new blocks, and the set of `@p`s that have been disallowed from adding new blocks due to established bad behavior. 

Please note that the real implementation of `%token` should used versioned states and versioned data structures, and this versioning boilerplate has been omitted for simplicity. 
### Proof of Identity Protocol

A `chain` is simply described as a list of `block`s. A more scalable implementation of `%token` might store the `chain` as a serialized data structure rather than a linked list. In any case, a `(list block)` should be possible to reconstruct from a given `chain`. 

A `block` must have the necessary information to:
* Establish the block's order in reference to the other blocks in the chain (block height, `hght`)
* Attest the hash of the previous block height (`prev`) 
* Attest the hash of all of its own transactions as a Merkle Root (`root`)
* Stamp the time at which the block was minted (`stmp`)
* Provide a list of transactions to be included in the block (`txns`)
* Provide the identity of the entity submitting the block (`mint`)
* Establish whether or not this block is a null-block, slashing its intended minter (`slsh`)

```hoon
+$  chain  (list block)
+$  block
  $:
    hght=@ud
    prev=@uvH
    root=@uvH
    stmp=@da
    txns=(list txn)
    mint=@p
    slsh=?
  ==
```

The Proof of Identity Protocol follows rather straightforwardly out of these data structures. It can be summarized as follows:

* The original state of the chain can be assumed to be the following: a single validator who holds 100% of the tokens is the only validator in the set. 
    * For example, imagine the chain begins on `~zod` and consists of `1.000.000` tokens. The `shared-state` prior to any blocks would be as follows:
        * `ledger: {~zod: 1.000.000}`
        * `validators: {~zod}`
        * `blacklist: ~`
    * This is a separate question from the initial token allocation, which will consist of transactions performed by the minter of the genesis block. 
* A genesis block is submitted, containing zero transactions. 
* Full nodes that have the full state of the chain will go into the following main loop:
    * A validator is elected based on a deterministic function from the last state of the chain. The height of the last block is used as entropy to generate a random number between `0` and `(dec (lent validators))`. This random number is mapped to an index in `validators` and the resulting `@p` of that index is elected to validate the next block.
    * All of the full nodes subscribe to the elected validator to await a new block. 
    * The elected validator, along with the other validators, gossip transactions around the network. 
    * The elected validator checks the signatures of gossiped transactions. If the signatures are valid, it adds them to the block. 
    * When a list of transactions has been completed, the validator signs the block and releases it. 
        * Creating this signature and constructing a valid block is a complex process that we will black box for the time being in this spec. 
    * If the block is valid, the full nodes add the block to their chain and repeat the loop. The validator claims the `bid` token values from the submitted transactions. 
    * If the block is invalid, the full nodes reject the block and continue to wait for a valid block from the validator. 
    * If a specified time has passed (to be determined based on network performance during testing) and no valid block has been submitted, the full nodes add a null block to the chain and elect a new validator and repeat the loop. 
        * The `mint` value of the null block is the `@p` of the validator whose turn it was to submit a block. 
        * The cryptographic hashes of the null block are null.
        * The `slsh` value is set to `%.y`, indicating that the `mint` validator is to be slashed. 
        * The shared state of the chain is updated to add the validator to the blacklist with a timestamp of `(add stmp d)` where `stmp` is used from the previous block and `d` is the hard-coded time limit to submit a valid block.
    * A blacklisted `@p` will be excluded from the eligible validator set for a specified time, such as three months. (the specified time will be hard-coded and should be decided as a result of testing)

## Justification

Previous attempts to build a Byzantine fault-tolerant consensus network on Urbit have failed. I posit that it is necessary to think through the Urbit-blockchain relationship from scratch, lean into Urbit's strengths, and design for simplicity over power. `%token` explicitly opts out of compatibility, composability, scalability, or generality contests and instead provides only what it says on the box: a plausibly secure consensus network that maps an Urbit ID to a `$TOKEN` balance. 

`$TOKEN` does not claim to be money and has no ideological or investment thesis. It is simply a token that can be deposited by its owner. 

If `%token` is successful, it should inspire a fair array of derivative art, which could feasibly be more powerful. However, if `%token` is created quickly enough to be the first mover on Mars, and simply enough to be kelvin versioned, `$TOKEN` may retain some long-term value. 

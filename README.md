`%chain` is a research project into achieving Byzantine fault-tolerant state machine replication (BFT-SMR) within the context of an Urbit application. If successful, this project will result in an application `%chain` that integrates well with other Urbit applications and improves the utility of Urbit ID. 

`%chain` is a young project and some aspects of it are difficult to document due to liability to change. We will here highlight the overall goals and strategy of the project, and encourage readers to inspect the repo or reach out to developers with specific questions. 
## Goals

The final goal of `%chain` is to build a blockchain with an indefinite lifespan. By building on top of Urbit OS, which aims to be finally specified as a frozen standard, `%chain` similarly aims standardize its protocol as an Urbit application that does not need to update in order to survive. This is simultaneously the farthest-reaching goal of the project and also the most foundational guiding principle. 

There are some other goals in mind for the `%chain` project that are worth considering. 

* Establish a canonical Urbit blockchain called `%chain`. Provide developers with a source of shared truth that can be trusted to also be the source of shared truth for other Urbit applications. Establish a commanding network effect within the Urbit ecosystem. 
* Establish a canonical Urbit currency called `$TOKEN`. Provide the market with a fungible token that is broadly accepted as a form of payment by Urbit users, can easily be integrated into any Urbit application, and whose value can be expected to correlate with the degree of economic activity on Urbit. 
* Leverage Urbit ID for sybil resistance. This includes restricting validation rights to higher-level nodes such as stars and galaxies. There may be a case in which the sybil resistance properties of planets is applicable, such as in spam resistance for fee-less payment systems. 
* Provide an upside to address space holders. Treat investors in Urbit ID as first-class citizens of the Urbit economy and seek to maximize the correlation between `$TOKEN` value and address space value. 
* Integrate Urbit ID as a native blockchain account. Allow tokens to be sent directly to and from an Urbit ID, in addition to a public key account as is normal in blockchain networks elsewhere. 
* Make it easy for Urbit users to run full nodes on their own ships and independently verify the state of the network. 

The above goals should be considered core goals of the project and will not be changed unless in light of severe feasibility constraints. There are some other project goals that are more loosely held, and are worth mentioning. 

* Establish a canonical Urbit-native DNS alternative. Allow users to register, buy, sell and renew arbitrary names on `%chain`. 
    * For example, it should be possible to register a trademark such that one can query it and resolve to a registered Urbit ID under that trademark. It should also be possible for a developer to attest the Hoon definition of a mark file on chain, to avoid the need for ad-hoc social consensus around marks. 
* Provide a plausible new home for the Urbit PKI, such that it no longer needs to live on Ethereum. Offer a way to simplify the core Urbit codebase and reduce external dependencies. 
* Allow users and developers to mint and distribute novel tokens of their own creation, both of the fungible and non-fungible varieties, and integrate these tokens into their own applications.
* Allow users and developers to create DAOs on-chain, defined as a set of `@p`s and a denotation of privileges between them, in order to create social networks that are more fault-tolerant than federated groups and forums. 
* Integrate `%chain` with other blockchain environments, such as Cosmos Hub, and enable users to bridge assets into `%chain` from other networks and vice versa. 
* Create a smart contracting platform that integrates with Urbit applications. Allow developers to write smart contracts in Hoon (or any Nock-compiled language) and publish them to `%chain`. 

The feasibility of each of these goals will need to be held in tension with the overall goal of permanent standardization. For example, a PKI integration may not be possible if it necessitates a constant compatibility layer with Ethereum that is liable to change. For a different example, a smart contracting platform may incur a never-ending arms race against attackers and competitors, which could prevent standardization. 

## Strategy

The `%chain` project's strategy has rapidly shifted since its inception and is liable to continue to change. The goals outlined above can be looked at as a guidestone, and the Kelvin Zero objective as the north star. 

There does not yet exist a BFT-SMR network on Urbit. Some attempts have been made to reach or approximate this goal, but as of this writing none of them are active. There is a project called Nockchain that aims to build a blockchain with a great degree of compatibility with Urbit applications, but it is not itself an Urbit application, nor is it running natively on the Urbit network. 

The opinion of the `%chain` developers is that BFT-SMR, normally considered an incredibly difficult problem domain, is well-suited to Urbit's application model. In particular, programmer overhead for messaging, broadcast, discovery, sybil resistance, cryptography, and much more is handled natively by Urbit OS. There is still an inherent perniciousness to the details of consensus algorithms, but the overhead is drastically reduced in any case. 

We will begin by creating a reference implementation for two BFT consensus algorithms, `%clockwork` and `%frontier`, to investigate the suitability of two competing approaches to BFT-SMR within the context of an Urbit application. 
  * `%clockwork` is inspired by the Tendermint protocol and aims to carefully keep a set of nodes in sync with each other as state transformations are voted on throughout a network, providing instant finality when a change is finally accepted. 
  * `%frontier` is inspired by the Avalanche protocol and allows nodes to keep a local state that is continuously updated by polling the network, with a guarantee to converge towards metastability at a dominant polling result. 

Both protocols will assume that every validator is either a star or a galaxy. To begin, the assumption may also be made that only planets, stars, and galaxies can participate and create transactions -- this will delay the need to implement fee/reward mechanisms too early. 

We will try one or both of our consensus algorithms with a test network that implements a payments system and a cryptocurrency `$TOKEN` live on Urbit. We will then iterate on this live test network continuously until the network is proven seaworthy enough for an official launch. 

Upon official launch, a Kelvin version will be assigned to the `%chain` codebase, and a steadfast commitment to the Kelvin versioning discipline will be maintained until the protocol is frozen as a standard. 

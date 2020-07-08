## Exchanges

An exchange intending to list ada can use a series of components, depending on whether the exchange wants to run a local block explorer with **specific APIs** or **custom APIs**.

**Running local block explorers with specific APIs**

If the exchange intends to run a local block explorer with *specific* APIs, they can use the following components:

-   cardano-node
-   cardano-db-sync
-   Postgresql DB
-   cardano-rest

**Running local block explorers with custom APIs**

If the exchange intends to run a local block explorer with *custom* APIs, they can use the following components:

-   cardano-node
-   cardano-db-sync
-   Postgresql DB
-   cardano-graphql  
-   cardano-node
-   cardano-wallet

### Adrestia Haskell SDK libraries

These libraries enable exchanges to create their own wallet and manage coin selection, address generation with serialization. The libraries are particularly useful for exchanges who want more control over UTXOs.

-   cardano-coin-selection
-   cardano-addresses
-   cardano-transactions
-   cardano-serialization-lib
-   bech32

### Operational guide and support

An operational guide and other resources for exchanges are available on the [IOHK support page](https://iohk.zendesk.com/hc/en-us/sections/360002109494-Exchange-integration).

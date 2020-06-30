Cardano Glossary
################

.. list-table:: Cardano Glossary
   :widths: auto auto
   :header-rows: 1

   * - Term
     - Definition
   * - Balance wallet
     - A Balance wallet is a wallet that stores your initial testnet ada balance, copied from the mainnet via the balance snapshot. The stake from this wallet cannot be delegated but can be transferred to and delegated from a Rewards wallet.
   * - Rewards wallet
     - A Rewards wallet is a wallet that stores ada which can be used in stake delegation. The stake from a single Rewards wallet can only be delegated to a single stake pool. To delegate to more than one stake pool, you will need to create multiple Rewards wallets and distribute ada among them.
   * - Epoch
     - An epoch is the period of time over which the blockchain produces its next set of blocks. On the Incentivized Testnet, an epoch lasts one day. Rewards are calculated at the end of each epoch and then distributed to delegators and stake pool operators. At the end of each epoch, the stake pools who will produce blocks in the next epoch are nominated (nomination affects performance, see below).
   * - Controlled stake
     - This is the total amount of stake that a stake pool controls. It combines the stake that is owned by the pool operator with any stake that has been delegated to the pool by other ada holders. It can be measured as a total ada amount (e.g. 3M ada), or as a percentage of the total supply of ada within the network (e.g. 5%).
   * - Performance
     - The performance of a stake pool, given as a percentage, is measured by how many blocks the stake pool has produced (and that are recorded on the main chain) compared to how many it was nominated to produce. For example, if a pool only produces half the number of blocks that it was nominated for, its performance rating is 50%. This could happen because the pool has a poor network connection, or has been turned off by its operator. Performance ratings make more sense over a longer period of time. If a pool has not yet been selected to produce a block in the current epoch, its performance rating will be 0%, even if it is likely to produce blocks later in the epoch. Performance ratings of over 100% are possible if a pool creates more blocks than it was nominated to produce.Since this is a testnet, performance ratings should only be used as a guide, and may be affected by network uptime, updates, or parameter changes.
   * - Produced blocks
     - This is the number of blocks that have been produced by a stake pool in the current epoch. Stake pools are rewarded in ada for each block that they produce.
   * - Block
     - A block is the basic unit of work in a blockchain. Stake pools compete to produce new cryptographically-verified blocks that are used to certify the validity of the cryptocurrency. Blocks are linked into a chain, with each block depending on the previous one (the blockchain). Network nodes (in the form of stake pools) collectively agree on which block should be the next one in the chain.
   * - Profit margin
     - The profit margin is the percentage of total ada rewards that the stake pool operator takes before sharing the rest of the rewards between all the delegators to the pool. A lower profit margin for the operator means they are taking less, which means that delegators can expect to receive more of the rewards for their delegated stake. A private pool is a pool with a profit margin of 100%, meaning that all the rewards will go to the operator and none to the delegators.
   * - Cost per epoch
     - This is a fixed fee, in ada, which the stake pool operator takes every epoch from the pool rewards to cover the costs of running a stake pool. The cost per epoch is subtracted from the total ada rewarded to a pool before the operator takes their profit margin. Whatever remains is shared with delegators.
   * - Saturation
     - Saturation is a term used to indicate that a particular stake pool has more stake delegated to it than is ideal for the network. Saturation is displayed as a percentage. Once a stake pool reaches 100% saturation, it will offer diminishing rewards.The saturation mechanism was designed to prevent centralization by encouraging delegators to delegate to different stake pools, and operators to set up alternative pools so that they can continue earning maximum rewards. Saturation, therefore, exists to preserve the interests of both ada holders delegating their stake and stake pool operators.

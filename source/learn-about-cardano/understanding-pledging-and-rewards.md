# Understanding Pledging and Rewards

Pledging is an important mechanism that encourages the growth of a healthy ecosystem within the Cardano blockchain. When you register a stake pool you can choose to pledge some, or all, of your ada to the pool, to make it more attractive to people that want to delegate. Although pledging is not required when setting up a stake pool, it can make the stake pool more attractive to delegators, as the higher the amount of ada that is pledged, the higher the rewards that will be paid out. The a0 protocol parameter defines the influence of the pledge on the pool reward.

*Understanding rewards*

During each epoch, rewards are distributed amongst all stakeholders who have delegated to a stake pool, either to their own stake pool, or another pool. These rewards come from two sources:
* All transaction fees: collated from the set of transactions included in a block that was minted during that epoch.
* Monetary expansion: involves distinguishing between the total supply of ada and the maximal supply of ada. The total supply consists of all ada currently in circulation, as well as the ada in the treasury. The maximal supply is the maximal amount of ada that can ever exist. The difference between these two figures is called the reserve. During each epoch, a fixed, (but parameterizable) percentage of the remaining reserve is taken from the reserve and used for epoch rewards and treasury, where the amount being sent to the treasury is a fixed percentage of the amount taken from the reserve.


The following formula outlines how the rewards mechanism works. The available rewards amount, transaction fees, plus monetary expansion, is denoted by R.
First, the share of all available rewards that a specific pool can receive is determined, as follows:
![pledge formula](https://github.com/cardano-foundation/testnets-cardano-org/blob/staging/resources/content/articles/article-images/pledge_formula.png)

These elements are defined as follows:
* <pre>R</pre> - total available rewards for this epoch
* <pre>a<sub>0</sub></pre> - pledge influence factor (can be between 0 and infinity)
* <pre>z<sub>0</sub></pre> - relative pool saturation size, i.e. 0.5% for a number of desired pool <pre>k</pre>=200
* <pre>σ</pre> - stake delegated to the pool (including stake pledged by the owners and stake delegated by others)
* <pre>σ’</pre> = <pre>min(σ, z<sub>0</sub>)</pre> - as <pre>σ</pre>, but capped at <pre>z<sub>0</sub></pre>
* <pre>s</pre> - stake pledged by the owners
* <pre>s’</pre> = <pre>min(s, z<sub>0</sub>)</pre> - as <pre>s</pre>, but capped at <pre>z<sub>0</sub></pre>

Note that <pre>z<sub>0</sub></pre>, <pre>σ</pre> and <pre>s</pre> are all relative, so they are fractions of the total supply, as they all lie between zero and one.

Two important considerations are:
1. Rewards increase with <pre>σ</pre>, but stop increasing once <pre>σ</pre> reaches <pre>z<sub>0</sub></pre>, that is. once the pool becomes saturated.
2. If <pre>a<sub>0</sub></pre>, (the pledge influence,) is zero, this formula simply becomes <pre>R·σ’</pre>,
   so it is proportional to pool stake, up to the point of saturation. For larger values of <pre>a<sub>0</sub></pre>, the pledge <pre>s</pre> becomes more important.

Remember that the pledge is declared during pool registration, (alongside the cost and margin values),
and has to be honored by the pool owners who are delegating to the pool:
If they collectively delegate less than the declared pledge, pool rewards for that epoch will be zero. Note that the pool will be public, if its operator margin is set to less than 100%.

The rewards that are produced by this formula are now adjusted by pool performance:
We multiply by <pre>β/σ</pre>, where <pre>β</pre> is the fraction of all blocks produced by the pool during the epoch.

For a perfectly performing pool, one that produces all blocks that it can produce, this factor will be one, on average. The actual value will fluctuate due to the stochastic nature, or random process. of the Ouroboros Praos consensus algorithm.

After pool rewards have been calculated and adjusted for pool performance, they are distributed amongst the pool operator and the pool members, or people who delegated part, or all of their stake, to the pool. This happens in several steps:

* First, the declared costs are subtracted and given to the pool operator.
* Next, the declared margin is subtracted and given to the pool operator..
* Finally the remainder is split fairly (proportional to delegated stake), amongst all people who delegated to the pool, including the pool owners.

A pledging calculator is available to use for estimation purposes. The rewards predicted by this calculator *are only an estimate*. The actual amount of ada received in rewards may vary, and will depend on a number of factors including; the actual stake pool performance, that is, the number of blocks a stake pool is observed to produce in a given epoch, versus the number it was expected to produce. Changes to network parameters may also affect rewards.

The annualized equivalent returns given by this calculator assume that stake is delegated to the same stake pool for a 365-day period, and that stake pool performance and other settings are consistent over that timeframe. IOHK accepts no responsibility for any discrepancy between estimated and actual rewards.

Disclaimer: this calculator is provided for guidance only.

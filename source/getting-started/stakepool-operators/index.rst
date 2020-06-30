Getting Started with Stakepool Operations
=========================================

Stake pools use the Cardano node to validate how the pool interacts with the network, sends transactions, creates blocks, and so on.

**Operating a stake pool**

Stake pools are a key part of a decentralized Cardano, supporting the mechanisms that ensure the long-term health and liveness of the network. By running a stake pool, stake pool operators enable other users to participate in the protocol and gain rewards without needing to continuously run an online node.

**Recommended setup**


As stake pool operator, you will have two types of nodes, block producing nodes and relay nodes. Each block producing node must be accompanied by several relay nodes.

To be clear: Both types of nodes run exactly the same program, cardano-node. The difference between the two types lies in how they are configured and how they are connected to each other:

* A block-producing node will be configured with various key-pairs needed for block generation (cold keys, KES hot keys and VRF hot keys). It will only be connected to its relay nodes.

* A relay node will not be in possession of any keys and will therefore be unable to produce blocks. It will be connected to its block producing node, other relays and external nodes.

Each node should run on a dedicated server, and the block-producing node's server's firewall should be configured to only allow incoming connections from its relays.



.. toctree::
   :maxdepth: 1
   :titlesonly:

   prerequisites
   hardware-requirements
   keys
   operational-certificate
   metadada
   public-stakepools
   metadata-proxy-servers

**How to create a stake pool:**

To learn how to setup your own stake pool, please follow the Cardano tutorials (add link)

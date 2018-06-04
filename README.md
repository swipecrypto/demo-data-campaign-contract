# demo-data-campaign-contract

This is the smart contract codes used to demonstrate data campaign within SWIPE network.

Contract attributes:
* minContributor: specify number of minimum contributor required before rewards can be disbursed to user.
* maxContributor: specify maximum number of contributors as per data buyer's budget.
* contributors: specify contributor address, publisher address, ipfs hash of the encrypted data, policy id, and capsule. Policy id and capsule is being used to perform reencryption.
* reward: specify number of SWIPE token to be distributed to users and publishers who contributed data.

Methods:
* contribute: records user consent to share encrypted data to data buyer.
* endCampaign: ends specific data campaign
* disburseReward: distributes rewards to contributors if no of contributor equals or more than minContributor attributes. Currently only logs reward distribution.

Considerations:
* Policy id and capsule which are used for data reencryption can only be accessible when campaign is ended and campaign meets number of minimum contributor.
* Reward is only distributed when campaign is ended and camapign meets number of minimum contributor.

## Please note the codes have not been audited and should only be used for demonstration purposes.

Future roadmaps:
* Implements reward distribution.
* Allows storing of data buyer SWIPE token payment and refund address.
* Rewards tiering for publishers and users.
* Security audit.

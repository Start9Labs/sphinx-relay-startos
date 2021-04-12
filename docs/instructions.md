# Sphinx Relay (Instructions)

## Bitcoin and LND Dependencies

Sphinx Relay depends on a fully-synced Bitcoin Node and Lightning Network Daemon (LND) node, and it requires LND to be configured properly. EmbassyOS will inform you of any configuration issues and fix them for you!

## Getting Liquidity (\*required)

Using Sphinx requires that you have _both_ inbound and outbound liquidity on your LND node with at least one other node that is well-connected to the Lightning Network. For best results, it is recommended that your channel have at least 100,000 sat (.001 BTC) capacity with at least 5,000 of that amount being _inbound_ capacity.

### Outbound

Getting outbound capacity is easy; just open a channel with a well-connected node and fund it with 100,000 sats. You can open a channel with Start9 [here](https://1ml.com/node/025d28dc4c4f5ce4194c31c3109129cd741fafc1ff2f6ea53f97de2f58877b2295) and/or you can open a channel with Sphinx's recommended node [here](https://github.com/stakwork/sphinx-relay/wiki/Home-node-FAQ).

### Inbound

Getting inbound liquidity is slightly harder. You have a few options:

1. Ask Start9 for an invoice. This will allow you to move a small amount of sats to our side of the channel, thus granting you inbound liquidity from almost anyone on the Lightning Network.
1. Get someone with a well-connected node to open a channel with you.

## Using Sphinx

Now that your LND node is running with inbound and outbound liquidity, to use Sphinx you need to connect a client app. Sphinx offers client apps for iOS, Android, Mac, Linux, and Windows.

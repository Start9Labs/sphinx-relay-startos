# Sphinx Relay (Instructions)

_Please read carefully, or you are going to have a bad time!_

## Bitcoin and LND Dependencies

Sphinx Relay depends on fully-synced Bitcoin and LND nodes, and it requires LND
to be configured properly. EmbassyOS will inform you if there are any
configuration issues and fix them for you!

## Getting Liquidity (\*required)

Using Sphinx requires that you have _both_ inbound and outbound liquidity on
your LND node with at least one other node that is well-connected to the
Lightning Network. For best results, it is recommended that your channel have at
least 100,000 sat (.001 BTC) capacity with at least 5,000 of that amount being
_inbound_ capacity. Follow
[these instructions](https://github.com/stakwork/sphinx-relay/wiki/Home-node-FAQ)
to open a channel in the recommended way. Following this guide to open a channel
to Sphinx's recommended node, pushing sats to the other side of the channel
during channel opening, will allow your node to send and receive zero-fee
transactions. This is the easiest way to have a smooth Sphinx Chat experience.

### Getting Outbound Liquidity

If you want to try connecting to nodes other than the recommended nodes, Sphinx
may not be able to find zero-fee routes as easily, but should still work. You'll
want to open channels to nodes that are well-connected, have good uptime, and
low latency. You can open a channel with
[Start9's node](https://1ml.com/node/025d28dc4c4f5ce4194c31c3109129cd741fafc1ff2f6ea53f97de2f58877b2295),
which is one such node.

### Getting Inbound Liquidity

Getting inbound liquidity is slightly harder. You have a few options:

1. Ask Start9 for an invoice. This will allow you to move a small amount of sats
   to our side of the channel, thus granting you inbound liquidity from almost
   anyone on the Lightning Network.
1. Ask someone with a well-connected node to open a channel with you.

### Get a Sphinx Client App

Now that your LND node is running with inbound and outbound liquidity, you are
ready to use Sphinx.

1. Download one of the official [Sphinx client apps](https://sphinx.chat) for
   iOS, Android, Mac, or Windows. Unfortunately the Linux and Windows versions
   do not yet support Tor. On Windows, some users report success using
   [Tallow](https://reqrypt.org/tallow.html) in conjunction with the Sphinx
   desktop app. If you are downloading the APK for Android, we recommend using
   Firefox.
1. Scan or copy your "Connection String" into the Sphinx client. This can be
   found inside the `Properties` page of your Sphinx Embassy service.

### Podcasting and Chat

The Sphinx Chat client app, when connected to your Embassy Sphinx Relay server,
offers decentralized podcasting, community channels (Tribes), and DMs. While the
DM feature is currently a bit slow and clunky, the Tribes and Podcasting
features work great. In our testing, the first DM was dropped, but after that
DMs went through eventually. YMMV. Following the
[official Sphinx setup guide](https://github.com/stakwork/sphinx-relay/wiki/Home-node-FAQ)
(as indicated above) will help optimize this experience.

### Lightning payments as spam control

The Sphinx Chat protocol uses Lighting micropayments to send messages using the
lightning network. This allows both DMs and Tribes to protect themselves against
spammers. These payments are refunded after a while if no spam/abuse is
detected.

### Back up your Sphinx Client App!

_Note: this is not the same as backing up Sphinx on your Embassy._

Go to Profile → (scroll to bottom) → Click "Export Keys" (Android) or "Backup
Your Key" (iOS).

This will copy a gigantic string of text to your device's clipboard. Paste it
somewhere safe, like Bitwarden!

Now, if you lose your device, or you want to run Sphinx on multiple devices, you
can enter this key when setting up Sphinx on the new device.

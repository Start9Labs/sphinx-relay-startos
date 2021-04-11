# Wrapper for shinx-relay

This project wraps [Sphinx Relay](https://sphinx.chat) for EmbassyOS. Sphinx Relay is a wrapper around Lightning Network Daemon LND, handling network connectivity and data storage. Communication between Relay nodes takes place entirely on the Lightning Network, so communications are decentralized, untraceable, and encrypted. Message content is also end-to-end encrypted using client public keys on the Sphinx Chat client apps.

## Dependencies

- [docker](https://docs.docker.com/get-docker)
- [docker-buildx](https://docs.docker.com/buildx/working-with-buildx/)
- [yq](https://mikefarah.gitbook.io/yq)
- [toml](https://crates.io/crates/toml-cli)
- [appmgr](https://github.com/Start9Labs/embassy-os/tree/master/appmgr)
- [make](https://www.gnu.org/software/make/)

## Cloning

Clone the project locally. Note the submodule link to the original project(s). 

```
git clone git@github.com:Start9Labs/sphinx-relay-wrapper.git
cd sphinx-relay-wrapper
```

## Building

To build the project, run the following commands:

```
make
```

## Installing (on Embassy)

SSH into an Embassy device.
`scp` the `.s9pk` to any directory from your local machine.
Run the following command to determine successful install:

```
appmgr install sphinx-relay.s9pk
```

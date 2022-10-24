# Wrapper for sphinx-relay

[Sphinx Chat](https://sphinx.chat) is a messaging service built on top of the Lightning Network. Each message sent and received on Sphinx is actually a transaction on Lightning. This serves to protect against spam and provides a means of monetizing content without trusted third parties. This repository creates the `s9pk` package that is installed to run `sphinx-relay` on [embassyOS](https://github.com/Start9Labs/embassy-os/).

## Dependencies

Install the following system dependencies to build this project by following the instructions in the provided links. You can also find detailed steps to setup your environment in the service packaging [documentation](https://github.com/Start9Labs/service-pipeline#development-environment).

- [docker](https://docs.docker.com/get-docker)
- [docker-buildx](https://docs.docker.com/buildx/working-with-buildx/)
- [yq](https://mikefarah.gitbook.io/yq)
- [toml](https://crates.io/crates/toml-cli)
- [make](https://www.gnu.org/software/make/)
- [embassy-sdk](https://github.com/Start9Labs/embassy-os/blob/master/backend/install-sdk.sh)
- [deno](https://deno.land/#installation)


## Cloning

Clone the project locally. Note the submodule link to the original project. 

```
git clone git@github.com:Start9Labs/sphinx-relay-wrapper.git
cd sphinx-relay-wrapper
```

## Installing (on embassyOS)

Run the following commands to install:

> :information_source: Change embassy-server-name.local to your Embassy address

```
embassy-cli auth login
# Enter your embassy password
embassy-cli --host https://embassy-server-name.local package install sphinx-relay.s9pk
```

If you already have your `embassy-cli` config file setup with a default `host`,
you can install simply by running:

```
make install
```

> **Tip:** You can also install the sphinx-relay.s9pk using **Sideload Service** under
the **Embassy > Settings** section.

### Verify Install

Go to your Embassy Services page, select **Sphinx Relay**, configure and start the service. Then, verify its interfaces are accessible.

**Done!** 
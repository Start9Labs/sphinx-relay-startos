ASSETS := $(shell yq e '.assets.[].src' manifest.yaml)
ASSET_PATHS := $(addprefix assets/,$(ASSETS))
VERSION := $(shell toml get sphinx-relay-configurator/Cargo.toml package.version)
SPHINX_RELAY_CFG_SRC := $(shell find ./sphinx-relay-configurator/src) sphinx-relay-configurator/Cargo.toml sphinx-relay-configurator/Cargo.lock

.DELETE_ON_ERROR:

all: sphinx-relay.s9pk

install: sphinx-relay.s9pk
	appmgr install sphinx-relay.s9pk

sphinx-relay.s9pk: config_spec.yaml config_rules.yaml image.tar instructions.md $(ASSET_PATHS)
	appmgr -vv pack $(shell pwd) -o sphinx-relay.s9pk
	appmgr -vv verify sphinx-relay.s9pk

instructions.md: README.md
	cp README.md instructions.md

image.tar: Dockerfile docker_entrypoint.sh sphinx-relay-configurator/target/armv7-unknown-linux-musleabihf/release/sphinx-relay-configurator
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --tag start9/sphinx-relay --platform=linux/arm/v7 -o type=docker,dest=image.tar .

sphinx-relay-configurator/target/armv7-unknown-linux-musleabihf/release/sphinx-relay-configurator: $(SPHINX_RELAY_CFG_SRC)
	docker run --rm -it -v ~/.cargo/registry:/root/.cargo/registry -v "$(shell pwd)"/sphinx-relay-configurator:/home/rust/src start9/rust-musl-cross:armv7-musleabihf cargo +beta build --release
	docker run --rm -it -v ~/.cargo/registry:/root/.cargo/registry -v "$(shell pwd)"/sphinx-relay-configurator:/home/rust/src start9/rust-musl-cross:armv7-musleabihf musl-strip target/armv7-unknown-linux-musleabihf/release/sphinx-relay-configurator

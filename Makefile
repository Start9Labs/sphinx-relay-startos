EMVER := $(shell yq e ".version" manifest.yaml)
ASSET_PATHS := $(shell find ./assets/*)
SPHINX_RELAY_CFG_SRC := $(shell find ./sphinx-relay-configurator/src) sphinx-relay-configurator/Cargo.toml sphinx-relay-configurator/Cargo.lock
SPHINX_RELAY_SRC := $(shell find ./sphinx-relay | grep -v node_modules)
S9PK_PATH=$(shell find . -name sphinx-relay.s9pk -print)

.DELETE_ON_ERROR:

all: verify

verify: sphinx-relay.s9pk $(S9PK_PATH)
	embassy-sdk verify s9pk $(S9PK_PATH)

install: sphinx-relay.s9pk 
	embassy-cli package install sphinx-relay.s9pk

sphinx-relay.s9pk: image.tar instructions.md instructions.md LICENSE icon.png $(ASSET_PATHS)
	embassy-sdk pack

image.tar: $(SPHINX_RELAY_SRC) Dockerfile docker_entrypoint.sh check-interface.sh sphinx-relay-configurator/target/aarch64-unknown-linux-musl/release/sphinx-relay-configurator
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --tag start9/sphinx-relay/main:${EMVER} --platform=linux/arm64/v8 -o type=docker,dest=image.tar .

sphinx-relay-configurator/target/aarch64-unknown-linux-musl/release/sphinx-relay-configurator: $(SPHINX_RELAY_CFG_SRC)
	docker run --rm -it -v ~/.cargo/registry:/root/.cargo/registry -v "$(shell pwd)"/sphinx-relay-configurator:/home/rust/src start9/rust-musl-cross:aarch64-musl cargo +beta build --release

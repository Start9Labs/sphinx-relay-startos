ASSETS := $(shell yq e '.assets.[].src' manifest.yaml)
ASSET_PATHS := $(addprefix assets/,$(ASSETS))
VERSION := $(shell toml get sphinx-relay-configurator/Cargo.toml package.version)
SPHINX_RELAY_CFG_SRC := $(shell find ./sphinx-relay-configurator/src) sphinx-relay-configurator/Cargo.toml sphinx-relay-configurator/Cargo.lock
S9PK_PATH=$(shell find . -name sphinx-relay.s9pk -print)

.DELETE_ON_ERROR:

all: verify

verify: sphinx-relay.s9pk $(S9PK_PATH)
	embassy-sdk verify $(S9PK_PATH)

sphinx-relay.s9pk: config_spec.yaml config_rules.yaml image.tar instructions.md $(ASSET_PATHS)
	embassy-sdk pack

image.tar: Dockerfile docker_entrypoint.sh sphinx-relay-configurator/target/aarch64-unknown-linux-musl/release/sphinx-relay-configurator
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --tag start9/sphinx-relay --platform=linux/arm64 -o type=docker,dest=image.tar .

sphinx-relay-configurator/target/aarch64-unknown-linux-musl/release/sphinx-relay-configurator: $(SPHINX_RELAY_CFG_SRC)
	docker run --rm -it -v ~/.cargo/registry:/root/.cargo/registry -v "$(shell pwd)"/sphinx-relay-configurator:/home/rust/src start9/rust-musl-cross:aarch64-musl cargo +beta build --release
	docker run --rm -it -v ~/.cargo/registry:/root/.cargo/registry -v "$(shell pwd)"/sphinx-relay-configurator:/home/rust/src start9/rust-musl-cross:aarch64-musl musl-strip target/aarch64-unknown-linux-musl/release/sphinx-relay-configurator

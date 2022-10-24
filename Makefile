PKG_VERSION := $(shell yq e ".version" manifest.yaml)
PKG_ID := $(shell yq e ".id" manifest.yaml)
SPHINX_RELAY_CFG_SRC := $(shell find ./sphinx-relay-configurator/src) sphinx-relay-configurator/Cargo.toml sphinx-relay-configurator/Cargo.lock
SPHINX_RELAY_SRC := $(shell find ./sphinx-relay | grep -v node_modules)
TS_FILES := $(shell find ./scripts -name '*.ts')

.DELETE_ON_ERROR:

all: verify

clean:
	rm -rf docker-images
	rm -f image.tar
	rm -f $(PKG_ID).s9pk
	rm -f js/*.js
	rm -rf sphinx-relay-configurator/target

verify: $(PKG_ID).s9pk
	embassy-sdk verify s9pk $(PKG_ID).s9pk

# assumes /etc/embassy/config.yaml exists on local system with `host: "http://embassy-server-name.local"` configured
install: $(PKG_ID).s9pk
	embassy-cli package install $(PKG_ID).s9pk

$(PKG_ID).s9pk: instructions.md instructions.md LICENSE icon.png manifest.yaml scripts/embassy.js docker-images/aarch64.tar docker-images/x86_64.tar
	if ! [ -z "$(ARCH)" ]; then cp docker-images/$(ARCH).tar image.tar; fi
	embassy-sdk pack

docker-images/aarch64.tar: $(SPHINX_RELAY_SRC) Dockerfile docker_entrypoint.sh sphinx-relay-configurator/target/aarch64-unknown-linux-musl/release/sphinx-relay-configurator
	mkdir -p docker-images
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --tag start9/$(PKG_ID)/main:$(PKG_VERSION) --platform=linux/arm64/v8 --build-arg PLATFORM=arm64 -o type=docker,dest=docker-images/aarch64.tar .

docker-images/x86_64.tar: $(SPHINX_RELAY_SRC) Dockerfile docker_entrypoint.sh sphinx-relay-configurator/target/x86_64-unknown-linux-musl/release/sphinx-relay-configurator
	mkdir -p docker-images
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --tag start9/$(PKG_ID)/main:$(PKG_VERSION) --build-arg ARCH=x86_64 --build-arg PLATFORM=amd64 -o type=docker,dest=docker-images/x86_64.tar .

sphinx-relay-configurator/target/aarch64-unknown-linux-musl/release/sphinx-relay-configurator: $(SPHINX_RELAY_CFG_SRC)
	docker run --rm -it -v ~/.cargo/registry:/root/.cargo/registry -v "$(shell pwd)"/sphinx-relay-configurator:/home/rust/src start9/rust-musl-cross:aarch64-musl cargo +beta build --release

sphinx-relay-configurator/target/x86_64-unknown-linux-musl/release/sphinx-relay-configurator: $(SPHINX_RELAY_CFG_SRC)
	docker run --rm -it -v ~/.cargo/registry:/root/.cargo/registry -v "$(shell pwd)"/sphinx-relay-configurator:/home/rust/src start9/rust-musl-cross:x86_64-musl cargo +beta build --release

scripts/embassy.js: $(TS_FILES)
	deno bundle scripts/embassy.ts scripts/embassy.js

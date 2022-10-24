import { types as T, matches } from "../deps.ts";

const { shape, boolean } = matches;

const matchLndConfig = shape({
    "accept-keysend": boolean
});

export const dependencies: T.ExpectedExports.dependencies = {
    lnd: {
      // deno-lint-ignore require-await
      async check(effects, configInput) {
        effects.info("check lnd");
        const config = matchLndConfig.unsafeCast(configInput);
        if (!config["accept-keysend"]) {
          return { error: 'Must have keysend for LND enabled' };
        }
        return { result: null };
      },
      // deno-lint-ignore require-await
      async autoConfigure(effects, configInput) {
        effects.info("autoconfigure lnd");
        const config = matchLndConfig.unsafeCast(configInput);
        config["accept-keysend"] = true;
        return { result: config };
      },
    },
  };

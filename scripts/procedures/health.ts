import { types as T, checkWebUrl, catchError } from "../deps.ts";

export const health: T.ExpectedExports.health = {
  // deno-lint-ignore require-await
  async "interface"(effects, duration) {
    return checkWebUrl("http://sphinx-relay.embassy:3300/app")(effects, duration).catch(catchError(effects))
  },
};
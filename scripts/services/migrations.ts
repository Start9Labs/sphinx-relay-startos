import { compat, types as T } from "../deps.ts";

export const migration: T.ExpectedExports.migration = compat.migrations
  .fromMapping(
    {
      "2.2.7": {
        up: compat.migrations.updateConfig(
          (config) => {
            return config;
          },
          true,
          { version: "2.2.7", type: "up" },
        ),
        down: compat.migrations.updateConfig(
          (config) => {
            return config;
          },
          true,
          { version: "2.2.7", type: "down" },
        ),
      },
    },
    "2.2.9",
  );

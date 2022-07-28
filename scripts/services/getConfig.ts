import { compat, types as T } from "../deps.ts";

export const getConfig: T.ExpectedExports.getConfig = compat.getConfig({
    "tor-address": {
       "name": "Network Tor Address",
       "description": "The Tor address for the network interface",
       "type": "pointer",
       "subtype": "package",
       "package-id": "sphinx-relay",
       "target": "tor-address",
       "interface": "network"
    }
 });
 
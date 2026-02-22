import { defineConfig } from "vite";
import swiftWasm from "@elementary-swift/vite-plugin-swift-wasm";

export default defineConfig({
  base: "/",
  plugins: [
    swiftWasm({
      useEmbeddedSDK: false,
    }),
  ],
});

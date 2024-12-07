import express from "express";
import http from "node:http";
import type { AddressInfo } from "node:net";
import { routes } from "./routes";

const { PORT } = process.env;

async function main(port: number) {
  const app = express();
  const httpServer = http.createServer(app);

  routes(app);

  await new Promise<void>((resolve) => httpServer.listen({ port }, resolve));
  const { address } = httpServer.address() as AddressInfo;
  console.log(`App ready at http://${address}:${port}`);
}

main(Number(PORT)).catch((error) => {
  console.error(error);
  process.exit(1);
});

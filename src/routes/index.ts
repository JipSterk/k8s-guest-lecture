import type { Application } from "express";

export function routes(app: Application) {
  app.get("/ping", (_req, res) => {
    res.status(200).send("pong");
  });

  app.get("/hello", ({ query }, res) => {
    const { subject = "World" } = query;
    res.status(200).send(`Hello ${subject}`);
  });

  app.get("/headers", ({ headers }, res) => {
    res.status(200).json(headers);
  });
}

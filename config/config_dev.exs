use Mix.Config

config Otomai.Backend,
  adress: "127.0.0.1",
  port:   5554

config Otomai.Frontend.Login,
  port: 5555,
  listeners: 1

config Otomai.Frontend.Realm,
  port: 5556

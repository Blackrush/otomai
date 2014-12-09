use Mix.Config

config Otomai.Backend,
  adress:    "127.0.0.1",
  port:      4444

config Otomai.Frontend.Login,
  port:      4445,
  listeners: 1

config Otomai.Frontend.Realm,
  port:      4446

import Config

config :signinapp_ex,
  timezone: "America/Bogota",
  env: :prod,
  http_port: 8083,
  enable_server: true,
  version: "0.0.1",
  custom_metrics_prefix_name: "signinapp_ex"

config :logger,
  level: :warning

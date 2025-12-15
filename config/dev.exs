import Config

config :signinapp_ex,
  timezone: "America/Bogota",
  env: :dev,
  http_port: 8083,
  enable_server: true,
  version: "0.0.1",
  custom_metrics_prefix_name: "signinapp_ex_local"

config :signinapp_ex,
  sign_up_write_gateway:
    SigninappEx.DrivenAdapters.Localstorage.Signup.Application.SignupWriteGateway

config :logger,
  level: :debug

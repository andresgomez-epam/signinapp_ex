import Config

config :signinapp_ex,
  timezone: "America/Bogota",
  env: :test,
  http_port: 8083,
  enable_server: true,
  version: "0.0.1",
  custom_metrics_prefix_name: "signinapp_ex_test"

config :signinapp_ex,
  sign_up_write_gateway:
    SigninappEx.Infrastructure.DrivenAdapters.Localstorage.Signup.Application.SignupWriteGateway,
  signin_read_gateway:
    SigninappEx.Infrastructure.DrivenAdapters.Localstorage.Signin.Application.SigninReadGateway,
  signin_write_gateway:
    SigninappEx.Infrastructure.DrivenAdapters.Localstorage.Signin.Application.SigninWriteGateway

config :logger,
  level: :info

config :junit_formatter,
  report_dir: "_build/release",
  automatic_create_dir?: true,
  report_file: "test-junit-report.xml"

config :elixir_structure_manager,
  sonar_base_folder: ""

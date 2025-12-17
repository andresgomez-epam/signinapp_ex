defmodule SigninappEx.Infrastructure.EntryPoints.RestController.Shared.Common.Infra.PrintEcsLog do
  @moduledoc """
  PrintEcsLog
  """
  require Logger

  alias SigninappEx.Infrastructure.EntryPoints.RestController.Shared.Common.Application.DataTypeUtils

  def print_ecs_log(log) do
    json_log = Poison.encode!(log)
    json_log_new = DataTypeUtils.normalize(json_log)
    Logger.error(json_log_new)
  end
end

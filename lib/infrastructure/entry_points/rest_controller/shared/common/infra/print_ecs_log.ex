defmodule SigninappEx.Infrastructure.EntryPoints.RestController.Shared.Common.Infra.PrintEcsLog do
  @moduledoc """
  PrintEcsLog
  """
  require Logger

  alias SigninappEx.Infrastructure.EntryPoints.RestController.Shared.Common.Application.DataTypeUtils

  def print_ecs_log(log) do
    log
    |> DataTypeUtils.mask_password()
    |> Poison.encode!()
    |> DataTypeUtils.normalize()
    |> Logger.info()
  end

  def print_ecs_log_error(log) do
    log
    |> DataTypeUtils.mask_password()
    |> Poison.encode!()
    |> DataTypeUtils.normalize()
    |> Logger.error()
  end
end

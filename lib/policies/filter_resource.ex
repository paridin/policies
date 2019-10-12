defmodule Policies.FilterResource do
  @moduledoc """
  This policies helps us to filter
  """

  def resource(%{assigns: %{current_user: user}} = _conn, :filter_mvno_id, %{
        results: data,
        roles: filtered_roles
      }) do
    case in_roles(user.role, filtered_roles) do
      true ->
        data
        |> Enum.filter(fn r -> r.mvno_id == user.mvno_id end)

      false ->
        data
    end
  end

  def policy_error(conn, :not_found) do
    Policies.ErrorHandlers.resource_not_found(conn, "Resource Not Found")
  end

  defp in_roles(role, roles) do
    roles
    |> Enum.any?(&(&1 == role))
  end
end

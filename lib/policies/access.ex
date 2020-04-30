defmodule Policies.Access do
  @moduledoc """
  Access Policies to be applied

  Handle the authorization to restrict pipelines must be part.

  The connection must have a user and an mvno logged to continue.

  """
  # set up support for policies
  use PolicyWonk.Policy
  # turn this module into an enforcement plug
  use PolicyWonk.Enforce
  require Logger

  def policy(assigns, {:current_user, %{struct: user_struct}}) do
    assigns[:current_user]
    |> continue?(user_struct)
  end

  def policy(%{current_user: user}, :user_active) do
    # This policy must be called after :current_user policy
    case user.active do
      true -> :ok
      false -> {:error, {:unauthorized, "Your account is inactive."}}
    end
  end

  def policy(%{current_user: user}, {:has_role, expected_role}),
    do: user.role |> in_roles([expected_role])

  def policy(%{current_user: user}, {:has_one_role, roles}), do: user.role |> in_roles(roles)

  def policy_error(conn, :unauthorized) do
    Policies.ErrorHandlers.unauthorized(conn)
  end

  def policy_error(conn, {:unauthorized, message}) do
    Policies.ErrorHandlers.unauthorized(conn, "/", message)
  end

  def policy_error(conn, {:login_required, message}) do
    Policies.ErrorHandlers.unauthenticated(conn, "/login", message)
  end

  def in_roles(role, roles) do
    roles
    |> Enum.any?(&(&1 == role))
    |> access?({:unauthorized, "Your account has not enough privileges."})
  end

  # privates
  # the following functions are part of our helpers
  defp continue?(nil, _struct), do: login_required()
  defp continue?(user, struct), do: valid_user_struct?(user.__struct__ == struct)

  defp access?(true, _message), do: :ok
  defp access?(false, policy_error), do: {:error, policy_error}

  defp valid_user_struct?(true), do: :ok
  defp valid_user_struct?(_), do: login_required()

  defp login_required, do: {:error, {:login_required, "Login required!"}}
end

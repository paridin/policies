defmodule Policies.ErrorHandlers do
  @moduledoc """
  Error handling
  """
  use Phoenix.Controller

  def unauthenticated(conn, to \\ "/login", error_str \\ nil) do
    conn
    |> put_flash(:error, error_str || "Unauthenticated")
    |> redirect(to: to)
    |> halt()
  end

  def unauthorized(conn, to \\ "/", error_str \\ nil) do
    conn
    |> put_flash(:error, error_str || "Unauthorized")
    |> redirect(to: to)
    |> halt()
  end

  def resource_not_found(conn, to \\ "/404", _error_str \\ nil) do
    conn
    |> put_status(404)
    |> put_flash(:error, "404 not found")
    |> redirect(to: to)
    |> halt()
  end
end

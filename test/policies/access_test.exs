defmodule Policies.AccessTest do
  @moduledoc """
  Access Test identify the global policies to get here.
  """
  use Policies.ConnCase, async: true

  alias Helper.User
  alias Policies.Access

  test "should have a :current_user", %{conn: conn} do
    conn =
      conn
      |> assign(:current_user, %User{})

    assert :ok == Access.policy(conn.assigns, {:current_user, %{struct: User}})
  end

  test "missing :current_user in assigns, returns an :error", %{conn: conn} do
    assert {:error, {:login_required, "Login required!"}} ==
             Access.policy(conn.assigns, {:current_user, %{struct: %{}}})
  end

  test "user must be active", %{conn: conn} do
    conn =
      conn
      |> assign(:current_user, %User{active: true})

    assert :ok == Access.policy(conn.assigns, :user_active)
  end

  test "user is inactive", %{conn: conn} do
    conn =
      conn
      |> assign(:current_user, %User{active: false})

    assert {:error, {:unauthorized, "Your account is inactive."}} ==
             Access.policy(conn.assigns, :user_active)
  end

  test "should have a valid rol", %{conn: conn} do
    conn =
      conn
      |> assign(:current_user, %User{active: true, role: "admin"})

    assert :ok == Access.policy(conn.assigns, {:has_role, "admin"})
  end

  test "should have an invalid rol", %{conn: conn} do
    conn =
      conn
      |> assign(:current_user, %User{active: true, role: "staff"})

    assert {:error, {:unauthorized, "Your account has not enough privileges."}} ==
             Access.policy(conn.assigns, {:has_role, "admin"})
  end

  test "should have a valid rol in a list", %{conn: conn} do
    conn =
      conn
      |> assign(:current_user, %User{active: true, role: "agent"})

    valid_roles = ["admin", "staff", "agent"]
    assert :ok == Access.policy(conn.assigns, {:has_one_role, valid_roles})
  end

  test "should have an invalid rol in a list", %{conn: conn} do
    conn =
      conn
      |> assign(:current_user, %User{active: true, role: "tor"})

    valid_roles = ["admin", "staff", "agent"]

    assert {:error, {:unauthorized, "Your account has not enough privileges."}} ==
             Access.policy(conn.assigns, {:has_one_role, valid_roles})
  end
end

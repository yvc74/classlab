defmodule Classlab.Classroom.MaterialControllerTest do
  alias Classlab.Material
  use Classlab.ConnCase

  @valid_attrs Factory.params_for(:material) |> Map.take(~w[type description title position url]a)
  @invalid_attrs %{title: ""}
  @form_field "material_title"

  setup %{conn: conn} do
    user = Factory.insert(:user)
    event = Factory.insert(:event)
    Factory.insert(:membership, event: event, user: user, role_id: 1)
    {:ok, conn: Session.login(conn, user), event: event}
  end

  describe "#index" do
    test "lists all entries on index", %{conn: conn, event: event} do
      material = Factory.insert(:material, event: event)
      conn = get conn, classroom_material_path(conn, :index, material.event)
      assert html_response(conn, 200) =~ material.title
    end
  end

  describe "#new" do
    test "renders form for new resources", %{conn: conn, event: event} do
      conn = get conn, classroom_material_path(conn, :new, event)
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#create" do
    test "creates resource and redirects when data is valid", %{conn: conn, event: event} do
      conn = post conn, classroom_material_path(conn, :create, event), material: @valid_attrs
      assert redirected_to(conn) == classroom_material_path(conn, :index, event)
      assert Repo.get_by(Material, @valid_attrs)
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn, event: event} do
      conn = post conn, classroom_material_path(conn, :create, event), material: @invalid_attrs
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#show" do
    test "shows chosen resource", %{conn: conn, event: event} do
      material = Factory.insert(:material, event: event)
      conn = get conn, classroom_material_path(conn, :show, material.event, material)
      assert html_response(conn, 200) =~ material.title
    end

    test "renders page not found when id is nonexistent", %{conn: conn} do
      assert_error_sent 404, fn ->
        get conn, classroom_material_path(conn, :show, -1, -1)
      end
    end
  end

  describe "#edit" do
    test "renders form for editing chosen resource", %{conn: conn, event: event} do
      material = Factory.insert(:material, event: event)
      conn = get conn, classroom_material_path(conn, :edit, material.event, material)
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#update" do
    test "updates chosen resource and redirects when data is valid", %{conn: conn, event: event} do
      material = Factory.insert(:material, event: event)
      conn = put conn, classroom_material_path(conn, :update, material.event, material), material: @valid_attrs
      assert redirected_to(conn) == classroom_material_path(conn, :show, material.event, material)
      assert Repo.get_by(Material, @valid_attrs)
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, event: event} do
      material = Factory.insert(:material, event: event)
      conn = put conn, classroom_material_path(conn, :update, material.event, material), material: @invalid_attrs
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#delete" do
    test "deletes chosen resource", %{conn: conn, event: event} do
      material = Factory.insert(:material, event: event)
      conn = delete conn, classroom_material_path(conn, :delete, material.event, material)
      assert redirected_to(conn) == classroom_material_path(conn, :index, material.event)
      refute Repo.get(Material, material.id)
    end
  end
end

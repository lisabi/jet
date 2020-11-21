defmodule JetWeb.PageController do
  use JetWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create_dump(conn, _params) do
    text(conn, "Dump created")
  end

  def view_dump(conn, _params) do
    text(conn, "Dump created")
  end
end

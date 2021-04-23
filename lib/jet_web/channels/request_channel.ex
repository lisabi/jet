defmodule JetWeb.RequestChannel do
  use Phoenix.Channel

  def join("requests:" <> sandbox_id, _payload, socket) do
    {:ok, %{message: "#{sandbox_id} joined"}, socket}
  end

  def handle_in("ping", _payload, socket) do
    {:reply, {:ok, %{message: "here"}}, socket}
  end
end

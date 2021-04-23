defmodule JetWeb.ChatChannel do
  use JetWeb, :channel

  def join("chat:" <> id, _payload, socket) do
    IO.inspect(id)
    {:ok, %{status: "connected"}, socket}
  end

  def handle_in("incoming_message", %{"message" => message}, socket) do
    # IO.inspect("New message")
    # IO.inspect(payload)
    broadcast!(socket, "updated_message", %{new_message: message})
    # push("reply", )
    {:noreply, socket}
  end

  # intercept ["response:updated"]
end

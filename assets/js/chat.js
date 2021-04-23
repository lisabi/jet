import { Socket } from "phoenix";
import vue from "vue";

let socket = new Socket("/socket", { params: { token: "window.userToken" } });
socket.connect();
let channel = socket.channel("chat:1", {});

channel
  .join()
  .receive("ok", (resp) => {
    console.log(resp);
  })
  .receive("error", (resp) => {
    console.log("Unable to join", resp);
  });

new vue({
  el: "#app",
  data: {
    messages: [],
    chatText: "",
  },

  methods: {
    handleSubmit(element) {
      channel.push("incoming_message", { message: this.chatText });
      this.chatText = "";
    },
  },

  mounted() {
    let vueInstance = this;
    channel.on("updated_message", (response) => {
      vueInstance.messages.push(response.new_message);
    });
  },
});

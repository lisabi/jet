import vue from "vue";
import axios from "axios";
import { Socket } from "phoenix";
let socket = new Socket("/socket", { params: { token: "window.userToken" } });
socket.connect();

// Now that you are connected, you can join channels with a topic:
let chanelToJoin = `requests:${sandboxId}`;
let channel = socket.channel(chanelToJoin, { sandbox_id: sandboxId });

channel
  .join()
  .receive("ok", (resp) => {
    console.log(resp);
  })
  .receive("error", (resp) => {
    console.log("Unable to join", resp);
  });

// channel.push("ping", { payload: "hello" });

new vue({
  el: "#app",
  data: {
    message: "Hello",
    showing: true,
    requests: [],
    rules: [
      { path: "/user", method: "POST" },
      { path: "/my/api/path", method: "GET" },
    ],
    showModal: false,
    isRuleTabActive: true,
    transitions: {
      fade: "fade",
    },
  },

  methods: {
    clearRequestTab() {
      this.requests = [];
    },

    showRulesTab() {
      this.showModal = this.isRuleTabActive = true;
      // this.isRuleTabActive = true;
    },

    closeRulesTab() {
      this.showModal = this.isRuleTabActive = false;
      // this.isRuleTabActive = false;
    },

    showRequestLog(sandboxId, element) {
      let clickedElement = element.target.parentElement;
      // = "bg-red-300";
      // console.log(clickedElement.classList);
      this.showing = false;
    },

    classObject(passedClass) {
      if (passedClass == "DEL") {
        return "text-red-500";
      } else if (passedClass == "GET") {
        return "text-blue-500";
      } else if (passedClass == "POST") {
        return "text-yellow-500";
      }
    },
  },

  mounted() {
    let vueInstance = this;
    axios.get(`/fetch_responses/${sandboxId}`).then(function ({ data }) {
      vueInstance.requests = data;
    });

    channel.on("response:new", (response) => {
      vueInstance.requests.push(response.request);
    });
  },
});

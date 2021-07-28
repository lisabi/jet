import vue from "vue";
import axios from "axios";
import { Socket } from "phoenix";
import hljs from "highlight.js";
import json from "highlight.js/lib/languages/json";
hljs.registerLanguage("json", json);
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

let verbs = ["get", "post", "put", "delete", "patch", "options", "head"].map((item) =>
  item.toUpperCase()
);

new vue({
  el: "#app",
  data: {
    verbs,
    showing: true,
    requests: [],
    rules: [{ path: "/users/1", method: "GET" }],
    showModal: true,
    isRuleTabActive: true,
    transitions: {
      fade: "fade",
    },
    rule: {
      method: "",
      path: "/",
      status_code: "",
      response_header: "",
      response_body: "",
      description: "",
    },
  },

  methods: {
    saveRule() {
      console.log(this.rule);
    },

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
      // this.showing = false;
    },

    toggleRequestDetailsTab(event) {
      let eventState = event.target.getAttribute("data-events-state");
      let elementToHide = event.target.nextElementSibling.nextElementSibling;
      let states = {
        show: "flex",
        hide: "hidden",
      };

      if (eventState == states.hide) {
        elementToHide.classList.remove(states.hide);
        elementToHide.classList.add(states.show);
        event.target.setAttribute("data-events-state", states.show);
      } else {
        elementToHide.classList.remove(states.show);
        elementToHide.classList.add(states.hide);
        event.target.setAttribute("data-events-state", states.hide);
      }
    },

    prettyPrint(json) {
      let html = hljs.highlight(JSON.stringify(json, null, 2), {
        language: "json",
      }).value;

      return html;
    },

    toggleIconsDisplay(param) {
      let rulesListIconsSet = param.target.children[1];

      let rulesListIconsAll = document.querySelectorAll(".rules-list-icons .icon");
      Array.from(rulesListIconsAll).forEach((element) => {
        element.classList.add("hidden");
      });

      Array.from(rulesListIconsSet.children).forEach((element) => {
        element.classList.remove("hidden");
      });
    },

    hideIconsDisplay() {
      let rulesListIconsAll = document.querySelectorAll(".rules-list-icons .icon");
      Array.from(rulesListIconsAll).forEach((element) => {
        element.classList.add("hidden");
      });
    },

    classObject(passedClass) {
      if (passedClass == "DELETE") {
        return "bg-red-500";
      } else if (passedClass == "GET") {
        return "bg-blue-500";
      } else if (passedClass == "POST") {
        return "bg-yellow-500";
      } else if (passedClass == "PUT") {
        return "bg-green-500";
      }
    },
  },

  mounted() {
    let vueInstance = this;
    axios.get(`/sandboxes/${sandboxId}`).then(function ({ data }) {
      vueInstance.requests = data;
    });

    channel.on("response:new", (response) => {
      vueInstance.requests.push(response.request);
    });
  },
});

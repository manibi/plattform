require("@rails/ujs").start();
// require("turbolinks").start();
require("@rails/activestorage").start();
require("channels");

// libraries
import Sortable from "sortablejs";
import "bootstrap";
import "../stylesheets/application";
import "./bootstrap_custom.js";
import "@fortawesome/fontawesome-free/js/all";

var el = document.getElementById("answers");
if (el) {
  var sortable = new Sortable(el, {
    animation: 150,
    ghostClass: "blue-background"
  });
  sortable();
}
// check flashcard answer
// import { check_flashcard_answer } from "../components/check_flashcard_answer";
// check_flashcard_answer();

require("@rails/ujs").start();
// require("turbolinks").start();
require("@rails/activestorage").start();
require("channels");
// require("jquery");

// libraries
import Sortable from "sortablejs";
import "bootstrap";
import "../stylesheets/application";
import "./bootstrap_custom.js";
import "@fortawesome/fontawesome-free/js/all";
import "cocoon";

// $(document).on("turbolinks:load", () => {
const flashcardDragListEl = document.getElementById("answers-drag");

if (flashcardDragListEl) {
  console.log("page has loaded!");
  const sortable = new Sortable(flashcardDragListEl, {
    animation: 150,
    ghostClass: "blue-background"
  });
  // sortable();
}
// });
// check flashcard answer
// import { check_flashcard_answer } from "../components/check_flashcard_answer";
// check_flashcard_answer();

require("@rails/ujs").start();
require("turbolinks").start();
require("@rails/activestorage").start();
require("channels");
require("trix");
require("@rails/actiontext");

// Support for IE
import "core-js/stable";
import "regenerator-runtime/runtime";
// require("jquery");

// libraries
import "bootstrap";
import "../stylesheets/application";
import "./bootstrap_custom.js";
import "@fortawesome/fontawesome-free/js/all";
import "cocoon";
import "select2";

import { autocompleteSearch } from "../components/autocompleteSearch";
import { playFlashcards } from "../components/playFlashcards";
import { authorView } from "../components/authorView";
import { emptySearchPage } from "../components/emptySearchPage";
import { check_multiple_choice_quiz } from "../components/check_multiple_choice_quiz";
import { check_match_answers_quiz } from "../components/check_match_answers_quiz";
import { check_correct_order_quiz } from "../components/check_correct_order_quiz";

document.addEventListener("turbolinks:load", () => {
  // gtag('config', 'UA-159154786-1');
  if (typeof gtag === "function") {
    gtag("config", "UA-159154786-1", {
      page_location: event.data.url
    });
  }
  authorView();
  playFlashcards();
  autocompleteSearch();
  emptySearchPage();
  check_multiple_choice_quiz();
  check_match_answers_quiz();
  check_correct_order_quiz();
  $(".select2").select2();
});

require("trix");
require("@rails/actiontext");

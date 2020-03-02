require("@rails/ujs").start();
require("turbolinks").start();
require("@rails/activestorage").start();
require("channels");
// require("jquery");

// libraries
import "bootstrap";
import "../stylesheets/application";
import "./bootstrap_custom.js";
import "@fortawesome/fontawesome-free/js/all";
import "cocoon";
import { autocompleteSearch } from "../components/autocompleteSearch";
import { playFlashcards } from "../components/playFlashcards";
import { authorView } from "../components/authorView";
import { emptySearchPage } from "../components/emptySearchPage";

document.addEventListener("turbolinks:load", () => {
  // gtag('config', 'UA-159154786-1');
  if (typeof gtag === 'function') {
    gtag('config', 'UA-159154786-1', {
      'page_location': event.data.url
    });
  }
  authorView();
  playFlashcards();
  autocompleteSearch();
  emptySearchPage();
});

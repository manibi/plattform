require("@rails/ujs").start();
// require("turbolinks").start();
require("@rails/activestorage").start();
require("channels");

// libraries
import "bootstrap";
import "../stylesheets/application";
import "./bootstrap_custom.js";
import "@fortawesome/fontawesome-free/js/all";

// check flashcard answer
import { check_flashcard_answer } from "../components/check_flashcard_answer";
check_flashcard_answer();

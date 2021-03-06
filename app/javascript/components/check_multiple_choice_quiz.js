const check_multiple_choice_quiz = () => {
  const form = document.getElementById("flashcardAnswerForm");
  const submitBtn = document.getElementById("mutipleChoiceSubmitBtn");
  const showResultBtn = document.getElementById("checkMutipleChoiceBtn");
  const flashcardAnswerEl = document.getElementsByClassName("flashcard-answer");
  const showExplanations = document.getElementById("showCorrectAnswers");
  const removePointerEvents = collection => {
    for (const el of collection) {
      el.classList.add("d-none");
      el.setAttribute("readonly", true);
    }
  };

  if (showResultBtn) {
    showResultBtn.addEventListener("click", e => {
      e.preventDefault();
      e.currentTarget.classList.add("d-none");
      removePointerEvents(flashcardAnswerEl);
      form.querySelectorAll("[data-check]").forEach(elem => {
        if (elem.getAttribute("data-check") === "true") {
          elem.parentElement.classList.add("correct-answer");
        } else if (elem.getAttribute("data-check") !== "true" && elem.checked) {
          elem.parentElement.classList.add("false-answer");
        }
      });
      showExplanations.classList.remove("d-none");
      submitBtn.classList.remove("d-none");
    });
  }
};

export { check_multiple_choice_quiz };

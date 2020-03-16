const check_multiple_choice_quiz = () => {
  const form = document.getElementById("flashcardAnswerForm");
  const submitBtn = document.getElementById("mutipleChoiceSubmitBtn");
  const showResultBtn = document.getElementById("checkMutipleChoiceBtn");
  const flashcardAnswerEl = document.getElementsByClassName("flashcard-answer");
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
      form.querySelectorAll("input[data-check='true']").forEach(elem => {
        elem.parentElement.classList.add("correct-answer");
      });
      submitBtn.classList.remove("d-none");
    });
  }
};

export { check_multiple_choice_quiz };

const check_flashcard_answer = () => {
  const form = document.getElementById("flashcardAnswerForm");
  const submitBtn = document.querySelector("input[type='submit']");
  const showResultBtn = document.getElementById("showResultBtn");
  const flashcardAnswerEl = document.getElementsByClassName("flashcard-answer");
  const removePointerEvents = collection => {
    for (const el of collection) {
      el.classList.add("remove-pointer");
    }
  };

  if (showResultBtn) {
    showResultBtn.addEventListener("click", e => {
      e.preventDefault();
      e.currentTarget.classList.add("d-none");
      removePointerEvents(flashcardAnswerEl);
      form
        .querySelector("input[value='true']")
        .nextElementSibling.classList.add("correct-answer");
      submitBtn.classList.remove("d-none");
    });
  }
};

export { check_flashcard_answer };

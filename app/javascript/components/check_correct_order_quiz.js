const check_correct_order_quiz = () => {
  const form = document.getElementById("flashcardAnswerForm");
  const submitBtn = document.getElementById("correctOrderSubmitBtn");
  const showResultBtn = document.getElementById("checkCorrectOrderBtn");
  const showExplanations = document.getElementById("showCorrectAnswers");
  const removePointerEvents = collection => {
    for (const el of collection) {
      el.classList.add("remove-pointer");
    }
  };
  const compareArrays = (arr1, arr2) => {
    for (let i = 0; i < arr1.length; i++) {
      if (arr1[i] !== arr2[i]) {
        return false;
      }
    }
    return true;
  };

  if (showResultBtn) {
    showResultBtn.addEventListener("click", e => {
      e.preventDefault();
      const flashcardAnswerEls = document.querySelectorAll("[data-check]");
      const flashcardAnswerOrder = Array.from(flashcardAnswerEls).map(el =>
        Number(el.getAttribute("data-check"))
      );
      const userAnswersOrder = [...flashcardAnswerOrder];
      const correctAnswerOrder = flashcardAnswerOrder.sort();

      e.currentTarget.classList.add("d-none");
      removePointerEvents(flashcardAnswerEls);

      if (compareArrays(userAnswersOrder, correctAnswerOrder)) {
        flashcardAnswerEls.forEach(elem => {
          elem.classList.add("correct-answer");
        });
      } else {
        flashcardAnswerEls.forEach(elem => {
          elem.classList.add("false-answer");
          const correctPlace =
            correctAnswerOrder.indexOf(
              Number(elem.getAttribute("data-check"))
            ) + 1;

          elem.textContent = `${correctPlace} - ${elem.textContent}`;
        });
      }
      showExplanations.classList.remove("d-none");
      submitBtn.classList.remove("d-none");
    });
  }
};

export { check_correct_order_quiz };

const check_match_answers_quiz = () => {
  const form = document.getElementById("flashcardAnswerForm");
  const submitBtn = document.getElementById("matchAnswersSubmitBtn");
  const showResultBtn = document.getElementById("checkMatchAnswersBtn");
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

  // document.querySelectorAll('[data-check]') select all li
  // get data-check attributtes
  // split array in 2 static and user answers(odd and even)
  // check if the 2 arrays are equal
  // add classes if equal or not
  // disable re-send

  if (showResultBtn) {
    showResultBtn.addEventListener("click", e => {
      e.preventDefault();
      const flashcardAnswerEls = document.querySelectorAll("[data-check]");
      const flashcardAnswerIds = Array.from(flashcardAnswerEls).map(el =>
        el.getAttribute("data-check")
      );
      const staticAnswers = flashcardAnswerIds.slice(
        0,
        flashcardAnswerIds.length / 2
      );
      const draggableAnswers = flashcardAnswerIds.slice(
        flashcardAnswerIds.length / 2,
        flashcardAnswerIds.length
      );

      e.currentTarget.classList.add("d-none");
      removePointerEvents(flashcardAnswerEls);

      if (compareArrays(staticAnswers, draggableAnswers)) {
        flashcardAnswerEls.forEach(elem => {
          elem.classList.add("correct-answer");
        });
      } else {
        flashcardAnswerEls.forEach(elem => {
          elem.classList.add("false-answer");
        });
      }
      showExplanations.classList.remove("d-none");
      submitBtn.classList.remove("d-none");
    });
  }
};

export { check_match_answers_quiz };

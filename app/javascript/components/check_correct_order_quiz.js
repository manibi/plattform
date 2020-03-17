const check_correct_order_quiz = () => {
  const form = document.getElementById("flashcardAnswerForm");
  const submitBtn = document.getElementById("correctOrderSubmitBtn");
  const showResultBtn = document.getElementById("checkCorrectOrderBtn");
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
      const flashcardAnswerOrder = Array.from(flashcardAnswerEls).map(el =>
        Number(el.getAttribute("data-check"))
      );
      const userAnswersOrder = [...flashcardAnswerOrder];

      e.currentTarget.classList.add("d-none");
      removePointerEvents(flashcardAnswerEls);

      if (compareArrays(userAnswersOrder, flashcardAnswerOrder.sort())) {
        flashcardAnswerEls.forEach(elem => {
          elem.classList.add("correct-answer");
        });
      } else {
        flashcardAnswerEls.forEach(elem => {
          elem.classList.add("false-answer");
        });
      }

      submitBtn.classList.remove("d-none");
    });
  }
};

export { check_correct_order_quiz };

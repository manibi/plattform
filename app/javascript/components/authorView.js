const authorView = () => {
  const answersEl = document.getElementById("uniqAnswers");
  const sollHabenViewBtnEl = document.getElementById("sollHabenView");
  const tableViewBtnEl = document.getElementById("tableView");

  if (sollHabenViewBtnEl) {
    sollHabenViewBtnEl.addEventListener("click", e => {
      e.preventDefault();
      answersEl.classList.toggle("soll-haben-view");
    });
  }

  if (tableViewBtnEl) {
    tableViewBtnEl.addEventListener("click", e => {
      e.preventDefault();
      answersEl.classList.toggle("table-view");
    });
  }
};

export { authorView };

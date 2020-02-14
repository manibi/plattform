import Sortable from "sortablejs";

const playFlashcards = () => {
  const flashcardDragListEl = document.getElementById("answers-drag");

  if (flashcardDragListEl) {
    new Sortable(flashcardDragListEl, {
      animation: 150,
      ghostClass: "blue-background"
    });
  }
};

export { playFlashcards };

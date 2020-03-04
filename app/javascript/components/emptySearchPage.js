const emptySearchPage = () => {
  const searchItems = document.getElementById('searchItems');
  const emptySearch = document.getElementById('emptySearch');

  if (searchItems && searchItems.childElementCount == 1) {
    emptySearch.textContent = "Nichts gefunden, versuche es nochmal.";
  }
}
export { emptySearchPage };
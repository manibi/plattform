const emptySearchPage = () => {
  const searchItems = document.getElementById('search-items');
  if (searchItems && searchItems.children.length == 0) {
    searchItems.textContent = "Try again!"
  }
}

export { emptySearchPage }
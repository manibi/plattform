import "easy-autocomplete/dist/jquery.easy-autocomplete";

const autocompleteSearch = () => {
  // document.addEventListener("turbolinks:load", e => {
  const $searchEl = $("#autocompleteSearch");
  const options = {
    getValue: "name",
    url: function(phrase) {
      return "/search.json?query=" + phrase;
    },
    categories: [
      {
        listLocation: "topics",
        header: "<b>Lernfelder</b>"
      },
      {
        listLocation: "categories",
        header: "<b>Kategorien</b>"
      },
      {
        listLocation: "articles",
        header: "<b>Artikel</b>"
      }
    ],
    list: {
      onChooseEvent: function() {
        var url = $searchEl.getSelectedItemData().url;
        $searchEl.val("");
        Turbolinks.visit(url);
      }
    }
  };
  $searchEl.easyAutocomplete(options);
  // });
};

export { autocompleteSearch };

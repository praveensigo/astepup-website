window.addEventListener("popstate", function (event) {
  history.pushState(null, "", window.location.href);
});

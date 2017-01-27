$(document).ready(function() {
  $('#search-dashboard').keyup(function(){
    var elements = $("#business-search-modal .business-name:visible").length;
    if (elements <= 1) {
      $( ".text-count" ).text( elements + " résultat");
    } else {
      $( ".text-count" ).text( elements + " résultats");
    }
  });
});

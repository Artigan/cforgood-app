$(document).ready(function() {
  $(".search-modal-button").click(function() {
    $(".search-modal").toggleClass("hidden");
    $('.search-category-overlay').toggleClass('hidden');
    $('#search-dashboard, #search-businesses, #search-assos').focus();
  });
});

$(document).ready(function() {
  $('.close-search-modal').click(function() {
    $(".search-modal").addClass('hidden');
    $('.search-category-overlay').toggleClass('hidden');
  });
});

$(document).ready(function(){

  // TOOGLE CATEGORY OVERLAY
  $('.search-category-overlay').click(function(event) {
    $('.search-modal').addClass('hidden');
  });

});

$(document).ready(function() {
  $(".search-modal-button-mobile").click(function() {
    $(".search-input-mobile").toggleClass("hidden");
    $(".search-modal-button-mobile").toggleClass("hidden");
    $('#search-in-navbar-mobile, #search-in-navbar-mobile-perks, #search-in-navbar-mobile-assos').focus();
    // $(".close.search-modal-button-mobile").toggleClass("hidden");
  });
});

$(document).ready(function() {
  $('#search-dashboard, #search-in-navbar-mobile').keyup(function(){
      $(".business-search-index-js").removeClass("hidden");
  });
});

$(document).ready(function() {
    $('.business-search-close-button-mobile, .business-search-close-button').click(function() {
      $('#search-dashboard').val('');
      $(".search-modal").addClass('hidden');
      $(".search-category-overlay").addClass('hidden');
      $(".business-search-index-js").addClass('hidden');
    });
});

$(document).ready(function() {
    var options = {
      valueNames: [ 'business-category-name', 'business-name', 'business-activity', 'perk-description', 'label-category' ]
    };

    var userList = new List('business-search-modal', options);

    $('#search-dashboard, #search-in-navbar-mobile').keyup(function(){
      userList.search($(this).val());
    });
});

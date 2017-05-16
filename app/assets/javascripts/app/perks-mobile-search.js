$(document).ready(function() {
  var options = {
    valueNames: [ 'business-category-name', 'business-name', 'business-activity', 'perk-description', 'label-category' ]
  };

  var userList = new List('businesses', options);

  $('#search-in-navbar-mobile-perks').keyup(function(){
    userList.search($(this).val());
  });
});

$( document ).ready(function() {
  if ($(this).scrollTop() > 0) {
    $('.navbar-wagon').removeClass('transparent')
  }
  else {
    $(".navbar-wagon").addClass('transparent')
  }
  // navbar transition jQuery script
  $(window).scroll(function(e){
    if ($(this).scrollTop() > 0) {
      $('.navbar-wagon').removeClass('transparent')
    }
    else {
      $(".navbar-wagon").addClass('transparent')
    }
  });

});
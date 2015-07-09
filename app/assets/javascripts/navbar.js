$(function(){
  $(window).scroll(function(e){
    if ($(this).scrollTop() > 0) {
      $(".navbar-wagon").css({
        "background": "rgba(0, 0, 0, 0.5)",
        "box-shadow": "0 0 2px black"
      });
    }
    else {
      $(".navbar-wagon").css({
        "background": "transparent",
         "box-shadow": "0 0 0px transparent"
      });
    }
  });
})
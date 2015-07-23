$(function(){
  $(window).scroll(function(e){
    if ($(this).scrollTop() > 200) {
      $(".navbar-wagon").css({
        "background": "rgba(54, 211, 218, 1)",
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
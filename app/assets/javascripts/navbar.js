$(function() {
  $(window).scroll(function(e) {
    if ($(this).scrollTop() > 200) {
      $(".navbar-wagon").css( {
        "background": "rgb(54, 211, 218)",
        //"background-image": 'url("../images/navbar1.png")',
        "box-shadow": "0 0 2px black"
      });
    }
    else if ($(this).scrollTop() > 0) {
      $(".navbar-wagon").css({
        "background": "rgba(0, 0, 0, 0.4)",
        "box-shadow": "0 0 0px transparent"
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
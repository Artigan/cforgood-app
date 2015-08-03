$(function() {
  $(window).scroll(function(e) {
    if ($(this).scrollTop() > 200) {
      $(".navbar-wagon").css( {
        "background": "-webkit-linear-gradient(90deg, #00C9FF 10%, #80F2A4 90%)", /* Chrome 10+, Saf5.1+ */
        "background": "-moz-linear-gradient(90deg, #00C9FF 10%, #80F2A4 90%)", /* FF3.6+ */
        "background": "-ms-linear-gradient(90deg, #00C9FF 10%, #80F2A4 90%)", /* IE10 */
        "background": "-o-linear-gradient(90deg, #00C9FF 10%, #80F2A4 90%)", /* Opera 11.10+ */
        "background": "linear-gradient(90deg, #00C9FF 10%, #80F2A4 90%)", /* W3C */
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
        "box-shadow": "0 0 0px transparent",
      });
    }
  });
})
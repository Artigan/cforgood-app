$(document).ready(function() {
  $(".perk-pseudo-modal-link").click(function() {
    var classModal = $(this).attr('id');
    $('.' + classModal).removeClass("hidden");
    $('.' + classModal).slideDown();
  });
});

$(document).ready(function() {
  $('.perk-modal-close').click(function() {
    $(".perk-modal-use").slideUp();
  });
});

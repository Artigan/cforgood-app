$(document).ready(function() {
  $(".perk-pseudo-modal-link").click(function() {
    var classModal = $(this).attr('id');
    $('.perk-card-container.' + classModal).addClass("open");
    $('.' + classModal).removeClass("hidden");
    $('.' + classModal).slideDown();
  });
});

$(document).ready(function() {
  $('.perk-modal-close').click(function() {
    $(".perk-modal-use").slideUp();
    $('.perk-card-container.open').removeClass('open');
  });
});

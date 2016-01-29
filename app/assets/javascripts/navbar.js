
if ($(window).width() > 768) {
  $(window).scroll(function(){
    if($(window).scrollTop() > 0){
      $('#navbar').addClass('navbar-scrolled');
    }else{
      $('#navbar').removeClass('navbar-scrolled');
    };
  });
};

$(document).ready(function(){
  $('.menu-toggle').click(function(event) {
    $('#navbar').toggleClass('menu-toggled');
    $('#menu-icon').toggleClass('open');
    $('#menu-overlay').toggleClass('hide-overlay');
    $('body').toggleClass('stop-scrolling');
    event.preventDefault();
    //$('body').bind('touchmove', function(e){e.preventDefault()})
  });
});

$(document).ready(function(){
  $('.business-filter a').click(function(){
    $('.business-filter .current').removeClass('current');
    $(this).addClass('current');

    var $container = $('.index-cards');
    var selector = $(this).attr('data-filter');
    $container.isotope({
      percentPosition: true,
      containerStyle: null,
      filter: selector,
      animationOptions: {
          duration: 750,
          easing: 'linear',
          queue: false
      }
    });
  });
});

// HIDE/SHOW DATE PICKER IF BON PLAN FLASH

$(document).ready(function(){
  if ($('#perk_permanent_false').prop('checked') === true ) {
    $('#perk_times').attr('placeholder', 'Quantité');
    $('.perk_periodicity_id').addClass('recurrence_hidden');
    $('#perk_periodicity_id').addClass('recurrence_hidden');
    $('#perk_start_date').removeClass('date_hidden');
    $('#perk_end_date').removeClass('date_hidden');
  };

  if ($('#perk_permanent_true').prop('checked') === true ) {
    $('#perk_times').attr('placeholder', 'Récurrence');
    $('.perk_periodicity_id').removeClass('recurrence_hidden');
    $('#perk_periodicity_id').removeClass('recurrence_hidden');
    $('#perk_start_date').addClass('date_hidden');
    $('#perk_end_date').addClass('date_hidden');
  };

  $('#perk_permanent_false').click(function(){
    $(".has-error").toggleClass("has-error");
    $(".help-block").remove();
    if ($('#perk_permanent_false').prop('checked') === true ) {
      $('#perk_times').attr('placeholder', 'Quantité');
      $('.perk_periodicity_id').addClass('recurrence_hidden');
      $('#perk_periodicity_id').addClass('recurrence_hidden');
      $('#perk_start_date').removeClass('date_hidden');
      $('#perk_end_date').removeClass('date_hidden');
    };
  });

  $('#perk_permanent_true').click(function(){
    $(".has-error").toggleClass("has-error");
    $(".help-block").remove();
    if ($('#perk_permanent_true').prop('checked') === true ) {
      $('#perk_times').attr('placeholder', 'Récurrence');
      $('.perk_periodicity_id').removeClass('recurrence_hidden');
      $('#perk_periodicity_id').removeClass('recurrence_hidden');
      $('#perk_start_date').addClass('date_hidden');
      $('#perk_end_date').addClass('date_hidden');
    };
  });
});

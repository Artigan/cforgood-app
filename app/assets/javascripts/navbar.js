
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

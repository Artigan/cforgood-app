
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

// HIDE/SHOW DATE PICKER IF BON PLAN FLASH

$(document).ready(function(){
  $('#perk_permanent_false').click(function(){
    if ($('#perk_permanent_false').prop('checked') === true ) {
      $('#perk_start_date').removeClass('date_hidden');
      $('#perk_end_date').removeClass('date_hidden');
    };
  });
  $('#perk_permanent_true').click(function(){
    if ($('#perk_permanent_true').prop('checked') === true ) {
      $('#perk_start_date').addClass('date_hidden');
      $('#perk_end_date').addClass('date_hidden');
    };
  });
});

google.maps.event.addListener(infowindow, 'ready', function() {
  var iwOuter = $('.gm-style-iw');
  var iwBackground = iwOuter.prev();
  iwBackground.children(':nth-child(2)').css({'display' : 'none'});
  iwBackground.children(':nth-child(4)').css({'display' : 'none'});

  iwOuter.parent().parent().css({left: '115px'});
  iwBackground.children(':nth-child(1)').attr('style', function(i,s){ return s + 'left: 76px !important;'});
  iwBackground.children(':nth-child(3)').attr('style', function(i,s){ return s + 'left: 76px !important;'});
  iwBackground.children(':nth-child(3)').find('div').children().css({'box-shadow': 'rgba(72, 181, 233, 0.6) 0px 1px 6px', 'z-index' : '1'});

  var iwCloseBtn = iwOuter.next();

  iwCloseBtn.css({
    opacity: '1', // by default the close button has an opacity of 0.7
    right: '38px', top: '3px', // button repositioning
    border: '7px solid #48b5e9', // increasing button border and new color
    'border-radius': '13px', // circular effect
    'box-shadow': '0 0 5px #3990B9' // 3D effect to highlight the button
    });

  iwCloseBtn.mouseout(function(){
    $(this).css({opacity: '1'});
  });
});
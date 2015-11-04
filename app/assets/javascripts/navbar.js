$window = $(window);
$window.scroll(function(){
  if($window.scrollTop() > 0){
    $('#navbar').addClass('navbar-scrolled');
  }else{
    $('#navbar').removeClass('navbar-scrolled');
  };
});

$('.menu-toggle').click(function() {
  $('burger').toggleClass('menu-checked');
  $('#navbar').toggleClass('menu-toggled');
});

$(document).on('click', '#sidebar > li', function () {
  $(this).siblings('li').hasClass('active').removeClass('active');
  $(this).addClass('active');
});
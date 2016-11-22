$(document).ready(function() {
    $(".search-modal-button").click(function() {
    $(".search-modal").toggleClass("hidden");
    });
});


$(document).ready(function() {
    $('.close-search-modal').click(function() {
    $(".search-modal").addClass('hidden');
    });
});

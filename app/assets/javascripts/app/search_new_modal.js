$(document).ready(function() {
    $(".search-modal-button").click(function() {
    $(".search-modal").removeClass("hidden");
    });
});


$(document).ready(function() {
    $('.close-search-modal').click(function() {
    $(".search-modal").addClass('hidden');
    });
});

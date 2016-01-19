function setRoutePathFromLocation() {
  if(navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(getPosition, geolocErrors, { maximumAge: 0, enableHighAccuracy: true});
  }
}

// function setBusinessesAroundMe() {
//   if(navigator.geolocation) {
//     navigator.geolocation.watchPosition(watchPosition, geolocErrors, { maximumAge: 0, enableHighAccuracy: true});
//   }
// }

// function watchPosition(position) {
//   var lat = position.coords.latitude
//   var lng = position.coords.longitude
// }

function getPosition(position) {
  var lat = position.coords.latitude
  var lng = position.coords.longitude
  var locale = $("#link-map").data("locale");
  var destination = $("#link-map").data("destination");
  var linkToNavigation = $("#link-map").attr("href");

  //saddr=latitude,longitude&daddr=latitude,longitude&hl=#{I18n.locale}
  linkToNavigation = linkToNavigation + "?saddr=" + lat + "," + lng
  + "&daddr=" + destination.latitude + "," + destination.longitude
  + "&hl=" + locale;

  //$("loader").hide();
  $("#link-map").removeAttr('disabled');
  $("#link-map").attr("href", linkToNavigation);
}

function geolocErrors(error) {
  var info = "Erreur lors de la géolocalisation : ";
  switch(error.code) {
    case error.TIMEOUT:
      info += "Timeout !";
    break;
    case error.PERMISSION_DENIED:
      info += "Vous n’avez pas donné la permission";
    break;
    case error.POSITION_UNAVAILABLE:
      info += "La position n’a pu être déterminée";
    break;
    case error.UNKNOWN_ERROR:
      info += "Erreur inconnue";
    break;
  }
  $("#link-map").after(info);
}

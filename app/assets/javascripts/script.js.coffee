$ ->
  # Find the users current location
  x = document.getElementById("demo")

  getLocation = () ->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition(showPosition)
    else
      x.innerHTML = "Geolocation is not supported by this browser."

  showPosition = (position) ->
    x.innerHTML = "Latitude: " + position.coords.latitude + "<br>Longitude: " + position.coords.longitude

  setUserLocation = () ->
    path = "/users/location/"+id
    $.ajax({
      type: "POST",
      url: path,
      dataType: "json",
      data: {longitude:, latitude}
      success: 
      })
  getLocation()
  console.log('hey')

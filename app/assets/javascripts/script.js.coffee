$ ->
  # Location for the geolocation not working message
  x = document.getElementById("demo")

  # Get user's location with flexible callback
  getLocation = (callback) ->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition(callback)
    else
      x.innerHTML = "Geolocation is not supported by this browser."

  # Set user location in user database to find closest bus stop
  setUserLocation = (position, successCallback) ->
    $.ajax({
      type: "GET",
      url: "/users/location/",
      dataType: "json",
      data: {longitude: position.coords.longitude, latitude: position.coords.latitude}
      success: successCallback
      })

  # Set user location to find closest bus stop, should be changed so that you don't need to reload the page
  $(".route-selection").on "click", (e) ->
    e.preventDefault()
    href = $(this).attr("href")
    getLocation (position) ->
      setUserLocation position, ->
        window.location = href

  # Equation to calculate the distance between two points with longitude and latitude
  getDistanceFromLatLonInKm = (lat1, lon1, lat2, lon2) ->
    R = 6371 # Radius of the earth in km
    dLat = deg2rad(lat2 - lat1) # deg2rad below
    dLon = deg2rad(lon2 - lon1)
    a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * Math.sin(dLon / 2) * Math.sin(dLon / 2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    d = R * c # Distance in km
    d
    console.log("inside getDistanceFromLatLonInKm")
    console.log("latitude1 is #{lat1}, latitude2 is #{lat2}, longitude1 is #{lon1}, longitude2 is #{lon2}")
    console.log(d)
    playAudioClip(d)

  deg2rad = (deg) ->
    deg * (Math.PI / 180)

  # Get json audio_clip data
  getAudioClips = (position) ->
    console.log("inside AudioClips")
    console.log(position)
    $.getJSON("/audio_clips").done (data) ->
      $(data).each (i, audio_clip) ->
        longitude = audio_clip.longitude
        latitude = audio_clip.latitude
        getDistanceFromLatLonInKm(latitude, longitude, position.coords.latitude, position.coords.longitude)

  # Play audio clip if in close proximity
  playAudioClip = (distance) ->
    if distance < 0.1
      alert("You're at the location!")

  # Check user location against landmarks
  checkLocation = ->
    console.log("checkLocation called")
    getLocation (position) ->
      console.log("inside getLocation")
      console.log(position)
      getAudioClips (position)


  checkLocation()

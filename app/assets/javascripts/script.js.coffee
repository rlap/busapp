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
  getDistanceFromLatLonInKm = (lat1, lon1, lat2, lon2, clip_id) ->
    R = 6371 # Radius of the earth in km
    dLat = deg2rad(lat2 - lat1) # deg2rad below
    dLon = deg2rad(lon2 - lon1)
    a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * Math.sin(dLon / 2) * Math.sin(dLon / 2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    d = R * c # Distance in km
    d
    # console.log("inside getDistanceFromLatLonInKm")
    # console.log("latitude1 is #{lat1}, latitude2 is #{lat2}, longitude1 is #{lon1}, longitude2 is #{lon2} for #{clip_id}")
    # console.log(d)
    playAudioClip(d, clip_id)

  deg2rad = (deg) ->
    deg * (Math.PI / 180)

  # Get json audio_clip data
  getAudioClips = (position) ->
    # console.log("inside AudioClips")
    # console.log(position)
    $.getJSON("/audio_clips").done (data) ->
      $(data).each (i, audio_clip) ->
        longitude = audio_clip.longitude
        latitude = audio_clip.latitude
        getDistanceFromLatLonInKm(latitude, longitude, position.coords.latitude, position.coords.longitude, audio_clip.id)

  # Play audio clip if in close proximity
  playAudioClip = (distance, clip_id) ->
    if distance < 0.1
      # alert("You're at the location!")
      id = clip_id
      # window.location = "/audio_clips/" + id

  # Check user location against landmarks
  checkLocation = ->
    console.log("checkLocation called")
    getLocation (position) ->
      # console.log("inside getLocation")
      # console.log(position)
      getAudioClips (position)

  # Get bus stop info to use in API call to TFL
  getStartStopInfo = ->
    $.getJSON("/userroutes/start_tour").done (data) ->
      LineID = data.route.name
      StopCode1 = data.stop.stop_code
      DirectionID = data.direction
      console.log("For this request the route is #{LineID} and the stop is #{StopCode1} and the direction is #{DirectionID}")
      getTflData(LineID, StopCode1, DirectionID)

  # Call to TFL api to get the next bus info
  getTflData = (LineID, StopCode1, DirectionID) ->
    requestUrl = "http://countdown.api.tfl.gov.uk/interfaces/ura/instant_V1?LineID=" + LineID + "&StopCode1=" + StopCode1 + "&DirectionID=" + DirectionID + "&ReturnList=StopPointIndicator,Towards,EstimatedTime,StopPointName,LineName"
    console.log(requestUrl)
    $.ajax({
      url:requestUrl, 
      dataType: "json", 
      complete: addNextBusInfo
      })

  # Manipulate TFL api data to make it usable
  addNextBusInfo = (response, xhrStatus) ->
    console.log("called addNextBusInfo")
    raw_data = response.responseText
    raw_data = raw_data.replace(/]/g, "],")
    raw_data = raw_data.substring(0, raw_data.length - 1);
    # raw_data = "[" + raw_data + "]" Ask Gerry why this doesn't do the same thing
    data = eval("["+raw_data+"]")
    bus_route = data[1][4]
    towards = data[1][2]
    stop = data[1][1]
    stop_letter = data[1][3]
    heading = "<h2> #{bus_route} bus towards #{towards} departing from #{stop} (bus stop #{stop_letter}) is arriving in... </h2> <ul>"
    $("#upcoming-buses").append(heading)
    current_time = new Date()
    $(data).each (i, bus) ->
      if i > 0 # First array of info from API is not a bus
        estimated_arrival = new Date(bus[5])
        time_to_arrival_ms = estimated_arrival - current_time
        time_to_arrival_min = Math.round(time_to_arrival_ms/60000)
        bus_arrival = "<li> #{time_to_arrival_min} min </li>"
        $("#upcoming-buses").append(bus_arrival)
    $("#upcoming-buses").append("</ul>")

  # Continually check for user location and whether there are at a landmark
  setInterval ->
    checkLocation()
  , 3000
  getStartStopInfo()

  # Add Google maps to app
  initialize = ->
    if window.location.pathname == "/map"
      console.log "google maps initialize called"
      mapOptions =
        center: new google.maps.LatLng(51.510154800000000000, -0.133829600000012760)
        zoom: 12

      map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions)
      return

  google.maps.event.addDomListener window, "load", initialize

  alert(window.location.pathname)

  # layout false 
  # ajax call datatype html 
  # inject inside model window 
  # Which clip are you on at the moment
  # Create html on page and then hide and unhide with page 
  # Put audio play into audio tag 
  # Later down the line play everything but pause 


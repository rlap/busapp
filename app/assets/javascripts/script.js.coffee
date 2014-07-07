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

  # Equation to calculate the distance between two points with longitude and latitude (4/7)
  getDistanceFromLatLonInKm = (lat1, lon1, lat2, lon2, clip_id, current_clip_id) ->
    console.log("getDistanceFromLatLonInKm 4")
    R = 6371 # Radius of the earth in km
    dLat = deg2rad(lat2 - lat1) # deg2rad below
    dLon = deg2rad(lon2 - lon1)
    a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * Math.sin(dLon / 2) * Math.sin(dLon / 2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    d = R * c # Distance in km
    d
    checkDistanceAndCurrentClip(d, clip_id, current_clip_id, setCurrentClip)

  deg2rad = (deg) ->
    deg * (Math.PI / 180)

  # Get users current audio_clip (2/7)
  getCurrentClip = (position) ->
    console.log("calling getCurrentClip 2")
    console.log(position)
    $.getJSON("/userroutes/start_tour").done (data) ->
      getAudioClips(position, data.current_clip_id)

  # Get json audio_clip data (3/7)
  getAudioClips = (position, current_clip_id) ->
    console.log("calling getAudioClips 3")
    $.getJSON("/audio_clips").done (data) ->
      $(data).each (i, audio_clip) ->
        longitude = audio_clip.longitude
        latitude = audio_clip.latitude
        getDistanceFromLatLonInKm(latitude, longitude, position.coords.latitude, position.coords.longitude, audio_clip.id, current_clip_id)

  # Play audio clip if in close proximity (5/7)
  checkDistanceAndCurrentClip = (distance, clip_id, current_clip_id, callback) ->
    console.log("calling checkDistanceAndCurrentClip 5")
    if distance < 0.1 && clip_id != current_clip_id
      callback(clip_id, playAudio)
      # alert("You're at the location!")
      # id = clip_id
      # window.location = "/audio_clips/" + id

  # Show audio clip and play (7/7)
  playAudio = ->
    console.log("calling playAudio 7")
    $('#lightbox').show();
    # alert("You're at the location!")

  # Hide the audio clip div if someone clicks on the back button
  $("#audio-back-button").on "click", (e) ->
    e.preventDefault()
    $("#lightbox").hide()


  # Set current clip ID (6/7)
  setCurrentClip = (clip_id, successCallback) ->
    console.log("calling setCurrentClip 6")
    $.ajax({
      type: "GET",
      url: "/set_current_clip",
      dataType: "json",
      data: {current_clip_id: clip_id}
      success: successCallback
      })

  # Check user location against landmarks (1/7)
  checkLocation = ->
    console.log("calling checkLocation 1")
    getLocation (position) ->
      console.log(position)
      getCurrentClip (position)

  # Get bus stop info to use in API call to TFL
  getStartStopInfo = ->
    $.getJSON("/userroutes/start_tour").done (data) ->
      LineID = data.route.name
      StopCode1 = data.stop.stop_code
      DirectionID = data.direction
      getTflData(LineID, StopCode1, DirectionID)

  # Call to TFL api to get the next bus info
  getTflData = (LineID, StopCode1, DirectionID) ->
    requestUrl = "http://countdown.api.tfl.gov.uk/interfaces/ura/instant_V1?LineID=" + LineID + "&StopCode1=" + StopCode1 + "&DirectionID=" + DirectionID + "&ReturnList=StopPointIndicator,Towards,EstimatedTime,StopPointName,LineName"
    $.ajax({
      url:requestUrl, 
      dataType: "json", 
      complete: addNextBusInfo
      })

  # Manipulate TFL api data to make it usable
  addNextBusInfo = (response, xhrStatus) ->
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

  # Add Google maps to app
  getRouteInfo = (callback)->
    routes = []
    $.getJSON("/routes").done (data) ->
      $(data).each (i, route) ->
        route_instance = []
        route_instance.push(route.id, route.name)
        routes.push(route_instance)
      callback(routes, createRouteMap)

  getRoutePathData = (routes, callback) ->
    pathHash = {}
    counter = 0
    $(routes).each (i, route) ->
      route_points = []
      route_name = route[1]
      route_id = route[0]
      $.getJSON("/route_sequences/" + route_id).done (data, status) ->
        $(data).each (i, point) ->
          route_points.push(new google.maps.LatLng(point.latitude, point.longitude))
        pathHash[route_name] = route_points
        counter++
        if(counter == routes.length)
          callback(pathHash)

  createRouteMap = (pathHash) ->
    if window.location.pathname == "/map"
      mapOptions =
        center: new google.maps.LatLng(51.510154800000000000, -0.133829600000012760)
        zoom: 12

      styles = [
        {
          "stylers": [
            { "weight": 1.8 },
            { "hue": "#0091ff" },
            { "saturation": -81 },
            { "lightness": -1 },
            { "gamma": 1.51 },
            { "visibility": "on" }
          ]
        },{
        }
      ]

      map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions)
      map.setOptions({styles: styles})

      routeNames = ["RV1", "139", "9", "274", "11", "15", "14"]
      routeColours = {"RV1":"#2ECC71", "139":"#1ABC9C", "9":"#3498DB", "274":"#9B59B6", "11":"#F1C40F", "15":"#E67E22", "14":"#E74C3C"}

      i = 0 
      while i < routeNames.length
        routeName = routeNames[i]

        j = 0
        polylinePoints = []
        while j < pathHash[routeName].length
          curPath = pathHash[routeName][j]
          polylinePoints.push(new google.maps.LatLng(curPath.k, curPath.B))
          j++
        routePath = new google.maps.Polyline({
          path: polylinePoints, 
          geodesic: true, 
          strokeColor: routeColours[routeName],
          strokeOpacity: 1.0,
          strokeWeight: 4
        })
        routePath.setMap(map)
        i++

  # Continually check for user location and whether there are at a landmark
  setInterval ->
    checkLocation()
  , 3000
  getStartStopInfo()
  google.maps.event.addDomListener window, "load", getRouteInfo(getRoutePathData)
  # $("#lightbox").hide()
  # layout false 
  # ajax call datatype html 
  # inject inside model window 
  # Which clip are you on at the moment
  # Create html on page and then hide and unhide with page 
  # Put audio play into audio tag 
  # Later down the line play everything but pause 


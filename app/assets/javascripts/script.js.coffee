$ ->
  # Location for the geolocation not working message
  x = document.getElementById("demo")

  # Get user's location with flexible callback
  getLocation = (callback) ->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition(callback)
    else
      x.innerHTML = "Geolocation is not supported by this browser."

   # Watch the users location to be used in google maps
  watchUserLocation = (callback) ->
    if navigator.geolocation
      navigator.geolocation.watchPosition(callback)
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
  getDistanceFromLatLonInKm = (lat1, lon1, lat2, lon2, clip_id, current_clip_id, audio_clip) ->
    R = 6371 # Radius of the earth in km
    dLat = deg2rad(lat2 - lat1) # deg2rad below
    dLon = deg2rad(lon2 - lon1)
    a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * Math.sin(dLon / 2) * Math.sin(dLon / 2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    d = R * c # Distance in km
    d
    checkDistanceAndCurrentClip(d, clip_id, current_clip_id, audio_clip, setCurrentClip)

  deg2rad = (deg) ->
    deg * (Math.PI / 180)

  # Get users current audio_clip (2/7)
  getCurrentClip = (position) ->
    $.getJSON("/userroutes/start_tour").done (data) ->
      getAudioClips(position, data.current_clip_id)

  # Get json audio_clip data (3/7)
  getAudioClips = (position, current_clip_id) ->
    $.getJSON("/audio_clips").done (data) ->
      $(data).each (i, audio_clip) ->
        longitude = audio_clip.longitude
        latitude = audio_clip.latitude
        getDistanceFromLatLonInKm(latitude, longitude, position.coords.latitude, position.coords.longitude, audio_clip.id, current_clip_id, audio_clip)

  # Play audio clip if in close proximity (5/7)
  checkDistanceAndCurrentClip = (distance, clip_id, current_clip_id, audio_clip, callback) ->
    if distance < 0.5 && clip_id != current_clip_id
      callback(clip_id, audio_clip, injectHtmlToAudioPage)
      # alert("You're at the location!")
      # id = clip_id
      # window.location = "/audio_clips/" + id

  # Show audio clip and play (7/7)
  injectHtmlToAudioPage = (audio_clip, callback) ->
    $("#popup-title-title-title").empty()
    $("#popup-title-title-title").append(audio_clip.name)
    $("#popup-img-img").attr("src", audio_clip.image_file)
    $("#tour-player").attr("src", audio_clip.audio_file)
    # STILL NEED TO ADD AUDIO FILE
    callback
    # $('#lightbox').show();
    # alert("You're at the location!")
    # $("#popup-img-img").attr("src","http://placekitten.com/200/300");
    # $("#popup-title-title").append("HELLO")

  # Unhide the attraction div and play audio 8
  showAudioPage = ->
    $('#lightbox').show();
    $("#tour-player").trigger('play')

  window.test = ->  
    # alert('Ended!')
    $("#lightbox").hide()

  # Hide the audio clip div if someone clicks on the back button
  $("#audio-back-button").on "click", (e) ->
    e.preventDefault()
    $("#lightbox").hide()

  # Set current clip ID (6/7)
  setCurrentClip = (clip_id, audio_clip, successCallback) ->
    $.ajax({
      type: "GET",
      url: "/set_current_clip",
      dataType: "json",
      data: {current_clip_id: clip_id}
      success: successCallback(audio_clip, showAudioPage)
      })

  # Check user location against landmarks (1/7)
  checkLocation = ->
    getLocation (position) ->
      getCurrentClip (position)

  # Get bus stop info to use in API call to TFL and to create google map
  getStartStopInfo = (position) ->
    console.log("inside getStartStopInfo")
    console.log(position)
    $.getJSON("/userroutes/start_tour").done (data) ->
      LineID = data.route.name
      StopCode1 = data.stop.stop_code
      DirectionID = data.direction
      getTflData(LineID, StopCode1, DirectionID)

  # Get bus stop info to use in API call to TFL and to create google map
  getStartStop = (position) ->
    console.log("inside getStartStopInfo")
    console.log(position)
    $.getJSON("/userroutes/start_tour").done (data) ->
      LineID = data.route.name
      StopCode1 = data.stop.stop_code
      DirectionID = data.direction
      createBusStopMap(data, position)

  # Call to TFL api to get the next bus info
  getTflData = (LineID, StopCode1, DirectionID) ->
    console.log("called getTflData")
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
    array = data[1]
    if array?
      bus_route = array[4]
      towards = array[2]
      stop = array[1]
      stop_letter = array[3]
    else
      bus_route = null
      towards = null
      stop = null
      stop_letter = null
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
        panControl: false
        zoomControl: true
        mapTypeControl: false
        zoomControlOptions: {
          style: google.maps.ZoomControlStyle.SMALL,
          position: google.maps.ControlPosition.TOP_RIGHT
        }

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

  # Create bus stop directions map
  createBusStopMap = (data,position) ->
    console.log("calling createBusStopMap")
    console.log(position)
    console.log(data)
    stopLatlng = new google.maps.LatLng(data.stop.latitude, data.stop.longitude)
    myLatlng = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)

    mapOptions =
      center: stopLatlng
      zoom: 12
      panControl: false
      zoomControl: true
      mapTypeControl: false
      zoomControlOptions: {
        style: google.maps.ZoomControlStyle.SMALL,
        position: google.maps.ControlPosition.TOP_RIGHT
      }

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

    map = new google.maps.Map(document.getElementById("bus-stop-map-canvas"), mapOptions)
    map.setOptions({styles: styles})

    markerStop = new google.maps.Marker(
      position: stopLatlng
      map: map
      title: data.stop.stop_name
      icon: "/assets/bus-stop.png"
      animation: google.maps.Animation.DROP
    )

    markerMyLocation = new google.maps.Marker(
      position: myLatlng
      map: map
      title: "your position"
      icon: 
        path: google.maps.SymbolPath.CIRCLE
        scale: 4
        strokeColor: "#3498DB"
    )

    #Automatically set zoom and center
    markers = [markerStop, markerMyLocation]
    bounds = new google.maps.LatLngBounds()
    i = 0
    while i < markers.length
      bounds.extend markers[i].getPosition()
      i++
    # center the map to the geometric center of all markers
    map.setCenter(bounds.getCenter())
    map.fitBounds(bounds) 

    # remove one zoom level to ensure no marker is on the edge
    map.setZoom(map.getZoom()-1)

    # set a minimum zoom 
    # if you got only 1 marker or all markers are on the same address map will be zoomed too much
    if (map.getZoom()> 15)
      map.setZoom(15);

    # add legend
    map.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(document.getElementById('legend'));

  # Continually check for user location and whether there are at a landmark
  if !!$("#tour_page").length
    setInterval ->
      checkLocation()
    , 3000
    # $("#lightbox").hide()
  if !!$('#map-canvas').length
    google.maps.event.addDomListener window, "load", getRouteInfo(getRoutePathData)
  if !!$('#bus-stop-map-canvas').length
    google.maps.event.addDomListener window, "load", watchUserLocation(getStartStop)
    getStartStopInfo()
    
   

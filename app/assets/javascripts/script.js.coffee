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
    $.getJSON("/landmarks").done (data) ->
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

  # Add Google maps to app
  getRouteInfo = (callback)->
    console.log("inside getRoutePathData")
    routes = []
    $.getJSON("/routes").done (data) ->
      $(data).each (i, route) ->
        route_instance = []
        route_instance.push(route.id, route.name)
        routes.push(route_instance)
      console.log("leaving getRouteInfo and passing on...")
      console.log(routes)
      callback(routes, createRouteMap)

  getRoutePathData = (routes, callback) ->
    console.log("calling getRoutePathData")
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
        # console.log("leaving getRoutePathData and passing on...")
        # console.log(pathHash)
        # console.log(pathHash[route_name])
        # console.log(pathHash[route_name].length)
    #console.log(pathHash)


  createRouteMap = (pathHash) ->
    if window.location.pathname == "/map"
      console.log("calling createRouteMap")
      #console.log(pathHash)
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
        console.log(routeName)
        console.log(pathHash[routeName])

        j = 0
        polylinePoints = []
        while j < pathHash[routeName].length
          curPath = pathHash[routeName][j]
          polylinePoints.push(new google.maps.LatLng(curPath.k, curPath.B))
          j++
        console.log("here are the polyPoints #{polylinePoints}")
        routePath = new google.maps.Polyline({
          path: polylinePoints, 
          geodesic: true, 
          strokeColor: routeColours[routeName],
          strokeOpacity: 1.0,
          strokeWeight: 4
        })
        routePath.setMap(map)
        i++

  # createRouteMap = (route_path) ->
  #   if window.location.pathname == "/map"
  #     console.log("inside createRouteMap")
  #     console.log(route_path)
  #     mapOptions =
  #       center: new google.maps.LatLng(51.510154800000000000, -0.133829600000012760)
  #       zoom: 12

  #     map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions)

  #     path = [
  #       new google.maps.LatLng(51.4793237895424, -0.194779450632099),
  #       new google.maps.LatLng(51.485536712418, -0.173807703649836),
  #       new google.maps.LatLng(51.4921077706049, -0.148407348447753)
  #     ]

  #     busRoute = new google.maps.Polyline({
  #       path: route_path, 
  #       geodesic: true, 
  #       strokeColor: '#FF0000',
  #       strokeOpacity: 1.0,
  #       strokeWeight: 2
  #     })

  #     busRoute2 = new google.maps.Polyline({
  #       path: path, 
  #       geodesic: true, 
  #       strokeColor: '#FF0000',
  #       strokeOpacity: 1.0,
  #       strokeWeight: 2
  #     })

  #     busRoute.setMap(map)
  #     busRoute2.setMap(map)

  # Create google map
  # google.maps.event.addDomListener window, "load", getRoutePathData(createRouteMap)

  # Continually check for user location and whether there are at a landmark
  setInterval ->
    checkLocation()
  , 3000
  getStartStopInfo()
  google.maps.event.addDomListener window, "load", getRouteInfo(getRoutePathData)

  # layout false 
  # ajax call datatype html 
  # inject inside model window 
  # Which clip are you on at the moment
  # Create html on page and then hide and unhide with page 
  # Put audio play into audio tag 
  # Later down the line play everything but pause 


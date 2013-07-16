# Geode
# ==========================
# Wrapper for http://www.geonames.org/ api in NodeJS Module form
#
request = require('request')

# @Constructor
# @Param username :String - username to geonames.org
# @Param local :Object - local information
# @local countryCode :String - eg. "US", "CA"
# @local language :String - eg. "en", "sp"
#
Geode = (username, local) ->
  that = @
  that.username = username ? null
  #that.countryCode = local?.countryCode ? 'US'
  that.language = local?.language ? 'en'
  that.endpoint = 'http://api.geonames.org/'
  if that.username?
    that.ready = true
  else
    console.log 'Username is required'

  that.localize =
    username: that.username
    # country: that.countryCode
    language: that.language

  
  # @Method error :Function - handle errors
  # @Param err :Object - Error object returned from request
  # @Param callback :Function - Function to pass error data back to
  #
  that.error = (err, callback) ->
    console.log err  if process.env.NODE_ENV isnt 'production'
    callback err, {}

  
  # @Method merge :Function - *utility* merging objects
  # @Params * :Objects - passed in via arguments array, objects to merge
  #
  that.merge = ->
    if typeof arguments[0] is 'object' and not arguments[0].length      
      base = arguments[0]
      i = 1

      while i < arguments.length
        for key of arguments[i]
          base[key] = arguments[i][key]
        i += 1
    base

  # @Method request :Function - sends out request to geonames server
  # @Param collection :String - corresponds to url endpoints in api
  # @Param data :Object - Payload to send in query string
  # @Param callback :Function - Function to pass error data back to
  #
  that.request = (collection, data, callback) ->
    url = that.endpoint + collection + 'JSON'
    payload = that.merge({}, that.localize, data)
    request.get
      url: url
      qs: payload
      json: true
    , (err, res, body) ->
      callback err, body
  
  # All method requirement can be found here
  #* http://www.geonames.org/export/web-services.html
  #
  that.methods = ['search', 'postalCode', 'postalCodeLookup', 'findNearbyPostalCodes', 'postalCodeCountryInfo', 'findNearbyPlaceName', 'findNearby', 'extendedFindNearby', 'children', 'hierarchy', 'neighbours', 'siblings', 'findNearbyWikipedia', 'wikipediaSearch', 'wikipediaBoundingBox', 'cities', 'earthquakes', 'weather', 'weatherIcaoJSON', 'findNearByWeather', 'countryInfo', 'countryCode', 'countrySubdivision', 'ocean', 'neighbourhood', 'srtm3', 'astergdem', 'gtopo30', 'timezone']
  
  # Compile methods
  for i, method of that.methods
    that[method] = ( (n)->
      (data, callback) ->
        that.request that.methods[n], data, callback
    )(i)

  return that

# Eg.
# that.search = function(data, callback){
# that.request('search', data, callback);
# };
#
module.exports = Geode
config = require('./config')
if not config?
  throw new Error "No weibo configuration found in this project"

request = require 'request'
FormData = require 'form-data'
querystring = require 'querystring'

baseUrl = 'https://api.weibo.com/2/'
apis = 
  upload: 'statuses/upload.json'
  getCountry: 'common/get_country.json'
  getProvince: 'common/get_province.json'
  getCity: 'common/get_city.json'

weibo =
  config: config
  errors:
    systemError                 : 10001
    serviceUnavailable          : 10002
    remoteServiceError          : 10003
    IPLimit                     : 10004
    permissionDenied            : 10005
    appkeyIsMissing             : 10006
    unsupportedMediatype        : 10007
    paramErrors                 : 10008
    systemBusy                  : 10009
    jobExpired                  : 10010
    RPCErrors                   : 10011
    illegalRequest              : 10012
    invalidWeiboUser            : 10013
    insufficientAppPermissions  : 10014
    missRequiredParameter       : 10016
    parameterValueInvalid       : 10017
    requestBodyLengthOverLimit  : 10018
    requestAPINotFound          : 10020
    HTTPMethodNotSupported      : 10021
    IPOutOfRateLimit            : 10022
    outOfRateLimit              : 10023
    requestOutOfRateLimit       : 10024    
    
    IDsRequired                 : 20001
    uidRequired                 : 20002
    userNotFound                : 20003
    unsupportedImageType        : 20005
    imageSizeTooLarge           : 20006
    usingMultipartRequired      : 20007
    contentRequired             : 20008
    tooManyIDs                  : 20009
    textTooLong                 : 20012
    textTooLong300              : 20013
    paramCheckErrors            : 20014
    accountOrIPOrAppIsIllgal    : 20015
    outOfLimit                  : 20016
    similarContent              : 20017
    containIllegalWebsite       : 20018
    repeatContent               : 20019
    containAdvertising          : 20020
    contentIsIllegal            : 20021
    strangeBehaviour            : 20022
    capchaRequired              : 20023
    successButDelayed           : 20032

    weiboNotFound               : 20101
    notYourOwnWeibo             : 20102
    cannotRepostSelfsWeibo      : 20103
    illegalWeibo                : 20104
    weiboIDRequired             : 20109
    repeatedWeiboText           : 20111

    authFalied                  : 21301
    tokenUsed                   : 21314
    tokenExpired                : 21315
    tokenRevoked                : 21316
    tokenRejected               : 21317
    authRevoked                 : 21319
    redirectURIMismatch         : 21322
    invalidRequest              : 21323
    invalidClient               : 21324
    unauthorizedClient          : 21326
    expiredToken                : 21327
    accessDenied                : 21330
    temporarilyUnavailable      : 21331
    invalidAccessToken          : 21332
    

  upload: (params, next) ->
    form = new FormData()
    form.append 'access_token', params.accessToken
    form.append 'status', encodeURIComponent params.status
    if config.annotations?
      form.append 'annotations', JSON.stringify config.annotations
    form.append 'pic', request.get(params.pic)

    form.submit baseUrl + apis.upload, (err, res) ->
      if err?
        next err
      else    
        data = ''
        res.on 'data', (chunk) ->
          data += chunk
        
        res.on 'close', (err) ->
          if err?
            next err
          
        res.on 'end', ->
          next null, { statusCode: res.statusCode, result: JSON.parse data }

  getCountry: (next) ->
    options = 
      url: baseUrl + apis.getCountry
      qs: source: config.weibo.clientId, language: 'english'
      json: true
    request options, (err, res, countries) ->
      if err?
        next err
      else
        next null, countries

  getProvince: (country, next) ->
    options = 
      url: baseUrl + apis.getProvince
      qs: source: config.weibo.clientId, country: country, language: 'english'
      json: true
    request options, (err, res, provinces) ->
      if err?
        next err
      else
        next null, provinces

  getCity: (country, province, next) ->
    options = 
      url: baseUrl + apis.getProvince
      qs: source: config.weibo.clientId, country: country, province: province, language: 'english'
      json: true
    request options, (err, res, provinces) ->
      if err?
        next err
      else
        next null, provinces

module.exports = weibo
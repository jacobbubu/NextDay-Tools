weibo = require './weibo'
async = require 'async'
inspect = require('util').inspect
fs = require 'fs'
Geode = require('./geode')

geode = new Geode('rong.shen@gmail.com')

getCity = (country, province, next) ->
  code = province.code
  weibo.getCity country, code, (err, cities) ->
    if err?
      next err
    else
      province.cities = ( {code: code, name: name} for code, name of cities )
      next null, cities

countryList = JSON.parse (fs.readFileSync './output/countryListWithGeonames.json', {encoding: 'utf8'})
#countryList = countryList.slice 8, 18

result = []

async.each countryList
, (country, done) ->
  weibo.getProvince country.weiboCode, (err, res) ->
    if err?
      done err
    else
      provinces = ( weiboProvCode: Object.keys(r)[0], name: r[Object.keys(r)[0]], countryCode: country.geoNames.countryCode for r in res )
      value = {
        weiboCode: country.weiboCode
        name: country.name
        countryCode: country.geoNames.countryCode
        provinces: provinces
      }
      result.push value
      done()
      
, (err) ->
  if err
    console.error err
  else
    fs.writeFileSync './output/provinceList.json', JSON.stringify(result, null, '  '), {encoding: 'utf8'}
    #console.log JSON.stringify result

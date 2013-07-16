weibo = require './weibo'
async = require 'async'
inspect = require('util').inspect
fs = require 'fs'

countryList = []

weibo.getCountry (err, countries) ->
  if err?
    console.error err
  else    
    for country in countries
      for code, name of country
        countryList.push {weiboCode: code, name: name}

    fs.writeFileSync './output/countryList.json', JSON.stringify(countryList, null, "  "), {encoding: 'utf8'}


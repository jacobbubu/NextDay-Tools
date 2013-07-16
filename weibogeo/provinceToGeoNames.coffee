fs = require 'fs'
async = require 'async'
Geode = require('./geode')

geode = new Geode('rong.shen@gmail.com')

countryList = JSON.parse(fs.readFileSync './output/provinceList.json', {encoding: 'utf8'})

result = []

async.each countryList
, (item, done) ->
  provinceList = item.provinces

  async.each provinceList
  , (prov, innerDone) ->

    options = 
      name: prov.name
      featureClass: 'A'
      country: prov.countryCode      
      style: 'FULL'

    geode.search options, (err, geoRes) ->
      if err?
        innerDone err
      else
        if geoRes.totalResultsCount is 0
          console.log prov.countryCode, prov.name, 'Not Found'
        else
          found = false
          for r in geoRes.geonames
            if r.fcode in ['ADM1', 'PCLS']
              prov.geoNames = r
              result.push prov
              found = true
              break
          if not found
            console.log prov.countryCode, prov.name, 'Not Found'
        innerDone()
  , (err) ->
    done err

, (err) ->
  if err?
    console.error err
  else
    fs.writeFileSync './output/provinceListWithGeonames.json', JSON.stringify(result, null, '  '), {encoding: 'utf8'}
    console.log 'done'
    #console.log JSON.stringify result
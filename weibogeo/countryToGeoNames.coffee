fs = require 'fs'
async = require 'async'
Geode = require('./geode')

geode = new Geode('rong.shen@gmail.com')

countryList = JSON.parse(fs.readFileSync './output/countryList.json', {encoding: 'utf8'})
#countryList = countryList.slice 0, 10

result = []

async.each countryList
, (country, done) ->
  name = country.name.replace '，', ' '
  options = 
    name: name
    featureClass: 'A'
    style: 'FULL'

  geode.search options, (err, res) ->
    if err?
      done err
    else

      switch res.totalResultsCount
        when 0
          result.push {
            weiboCode: country.weiboCode
            name: country.name
          }
        when 1
          result.push {
            weiboCode: country.weiboCode
            name: country.name
            geoNames: res.geonames[0]
          }
        else
          found = false
          for geo in res.geonames
            if geo.adminCode1 is '00'
              found = true
              result.push {
                weiboCode: country.weiboCode
                name: country.name
                geoNames: geo
              }
              break
          if not found
            result.push {
              weiboCode: country.weiboCode
              name: country.name
            }            
      done()

, (err) ->
  if err?
    console.error err
  else
    fs.writeFileSync './output/countryListWithGeonames.json', JSON.stringify(result, null, "  "), {encoding: 'utf8'}
    console.log JSON.stringify result

# options = 
#   name_equals: 'Northern Ireland'

# geode.search options, (err, res) ->
# 	if err?
#     console.log err
#   else
#     console.log res
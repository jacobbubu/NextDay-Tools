fs = require 'fs'

countryList = JSON.parse(fs.readFileSync './output/countryListWithGeonames.json')
provinceList = JSON.parse(fs.readFileSync './output/provinceListWithGeonames.json')

# timezoneList = {}

# for country in countryList
#   timezoneList[country.weiboCode] = country.geoNames.timezone.timeZoneId

# fs.writeFileSync './output/countryTimezone.json', JSON.stringify timezoneList, null, '  '

timezoneList = {}
for province in provinceList
  timezoneList[province.weiboProvCode] = province.geoNames.timezone.timeZoneId
  fs.writeFileSync './output/provinceTimezone.json', JSON.stringify timezoneList, null, '  '
  
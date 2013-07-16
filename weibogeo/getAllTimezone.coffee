fs = require 'fs'

countryList = JSON.parse(fs.readFileSync './output/countryListWithGeonames.json')
provinceList = JSON.parse(fs.readFileSync './output/provinceListWithGeonames.json')

console.log 'CountryList Count: ', countryList.length
console.log 'Province Count: ', provinceList.length

timezoneList = {}

for country in countryList
	if country?.geoNames?.timezone?.timeZoneId?
		timezoneList[country.geoNames.timezone.timeZoneId] = 1

for province in provinceList
	if province?.geoNames?.timezone?.timeZoneId?
		timezoneList[province.geoNames.timezone.timeZoneId] = 1		

timezoneList = Object.keys(timezoneList).sort()
console.log timezoneList.length

fs.writeFileSync('./output/timezoneList.json', JSON.stringify(timezoneList, null, '  '))
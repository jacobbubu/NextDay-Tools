
## tools ##

### jq ###

http://stedolan.github.io/jq/

## 找出没有成功匹配的国家 ##

cat countryListWithGeonames.json | jq 'map(select(has("geoNames") | not))'
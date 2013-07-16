Geode = require('./geode')

geode = new Geode('rong.shen@gmail.com')

options = 
  name: 'China'
  featureClass: 'A'
  style: 'FULL'
  country: 'CN'

geode.search options, (err, res) ->
	if err?
    console.log err
  else
    for geo in res.geonames
      #if geo.fcode in ['ADM1']
      if geo.adminCode1 is '00'
        console.log JSON.stringify geo
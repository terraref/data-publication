## Download Aggregated Weather Data from Geostreams API

# assume this is run from the code directory director

curl -k -L -X GET \
  -o ../metadata/weather/envlog_json/season_4_envlog.json \
  'https://terraref.org/clowder/api/geostreams/datapoints?stream_id=46431&since=2017-04-20&until=2017-09-18'  

curl -k -L -X GET \
  -o ../metadata/weather/envlog_json/season_6_envlog.json \
  'https://terraref.org/clowder/api/geostreams/datapoints?stream_id=46431&since=2018-04-06&until=2018-08-01' 


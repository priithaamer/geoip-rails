namespace :geoip do

  desc 'Download GeoLiteCity database from MaxMind'
  task :download do
    # wget -O /tmp/GeoLiteCity.zip http://geolite.maxmind.com/download/geoip/database/GeoLiteCity_CSV/GeoLiteCity_20110301.zip
    # unzip /tmp/GeoLiteCity.zip
    # mv /tmp/GeoLiteCity_20110301/*.* /tmp
  end
  
  desc 'Update database'
  task :updatedb do
    puts 'Update database stub'
  end
end

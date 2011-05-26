Implements efficient MaxMind GeoIP database queries in Rails. Read more about the techinque at [this fantastic article](http://jcole.us/blog/archives/2007/11/24/on-efficiently-geo-referencing-ips-with-maxmind-geoip-and-mysql-gis).

## Install

Add gem dependency to your Gemfile:

    gem 'geoip-rails'

## Usage

In your Rails app, `Geoip::Location` model is available. To get the location information for the user IP-address, call find_by_ip on it:

    Geoip::Location.find_by_ip('123.123.123.123')
    # => #<Geoip::Location id: 33447, country: "EE", region: "18", city: "Tartu", postal_code: 0, latitude: 58.3661, longitude: 26.7361, metro_code: 0, area_code: 0>

This method also accepts block that will be called when location is found by given ip address:

    Geoip::Location.find_by_ip('123.123.123.123') do |location|
      puts "I know that you live in #{location.city}"
    end

## TODO

See [GitHub issues list](https://github.com/priithaamer/geoip-rails/issues).

## Database schema

    CREATE DATABASE geoip;

    CREATE TABLE blocks (
      ip_poly      POLYGON       NOT NULL,
      ip_from      INT UNSIGNED  NOT NULL,
      ip_to        INT UNSIGNED  NOT NULL,
      location_id  INT(11)       NOT NULL,
      SPATIAL INDEX (ip_poly)
    ) ENGINE = MyISAM DEFAULT CHARSET = utf8;

    CREATE TABLE locations (
      id            INT(10)       UNSIGNED NOT NULL,
      country       CHAR(2)       NOT NULL,
      region        CHAR(2)       NOT NULL,
      city          VARCHAR(50)   NOT NULL,
      postal_code   INT(10)       UNSIGNED DEFAULT NULL,
      latitude      FLOAT         DEFAULT NULL,
      longitude     FLOAT         DEFAULT NULL,
      metro_code    INT(10)       UNSIGNED DEFAULT NULL,
      area_code     INT(10)       UNSIGNED DEFAULT NULL,
      PRIMARY KEY (id)
    ) ENGINE = MyISAM DEFAULT CHARSET = utf8;
    
## Import database from CSV files

    USE geoip;

    CREATE TABLE blocks_new (
      ip_poly      POLYGON       NOT NULL,
      ip_from      INT UNSIGNED  NOT NULL,
      ip_to        INT UNSIGNED  NOT NULL,
      location_id  INT(11)       NOT NULL,
      SPATIAL INDEX (ip_poly)
    ) ENGINE = MyISAM DEFAULT CHARSET = utf8;

    CREATE TABLE locations_new (
      id INT(10)    UNSIGNED    NOT NULL,
      country       CHAR(2)     NOT NULL,
      region        CHAR(2)     NOT NULL,
      city          VARCHAR(50) NOT NULL,
      postal_code   INT(10)     UNSIGNED DEFAULT NULL,
      latitude      FLOAT       DEFAULT NULL,
      longitude     FLOAT       DEFAULT NULL,
      metro_code    INT(10)     UNSIGNED DEFAULT NULL,
      area_code     INT(10)     UNSIGNED DEFAULT NULL,
      PRIMARY KEY (id)
    ) ENGINE = MyISAM DEFAULT CHARSET = utf8;

    LOAD DATA LOCAL INFILE "/tmp/GeoLiteCity-Blocks.csv"
    INTO TABLE blocks_new
    FIELDS
      TERMINATED BY ","
      ENCLOSED BY '\"'
    IGNORE 2 LINES
    (
      @start, @end, @location_id
    )
    SET
      ip_from       := @start,
      ip_to         := @end,
      ip_poly       := GEOMFROMWKB(POLYGON(LINESTRING(
          POINT(@start, -1),
          POINT(@end,   -1),
          POINT(@end,    1),
          POINT(@start,  1),
          POINT(@start, -1)
        ))),
      location_id := @location_id
    ;

    LOAD DATA LOCAL INFILE "/tmp/GeoLiteCity-Location.csv"
    INTO TABLE locations_new
    FIELDS
      TERMINATED BY ","
      ENCLOSED BY '\"'
    IGNORE 2 LINES
    (
      @id, @country, @region, @city, @postal_code, @latitude, @longitude, @metro_code, @area_code
    )
    SET
      id          := @id,
      country     := @country,
      region      := @region,
      city        := @city,
      postal_code := @postal_code,
      latitude    := @latitude,
      longitude   := @longitude,
      metro_code  := @metro_code,
      area_code   := @area_code
    ;

    RENAME TABLE blocks TO blocks_old;
    RENAME TABLE locations TO locations_old;
    RENAME TABLE blocks_new TO blocks;
    RENAME TABLE locations_new TO locations;

    DROP TABLE blocks_old;
    DROP TABLE locations_old;
    
    
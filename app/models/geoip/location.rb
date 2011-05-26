module Geoip
  class Location < Geoip::Base
    
    has_many :blocks
    
    def self.find_by_ip(ip, &block)
      location = self.joins(:blocks).where('MBRCONTAINS(ip_poly, POINTFROMWKB(POINT(INET_ATON(?), 0)))', ip).first
      
      if location and block_given?
        yield location
      else
        location
      end
    end
  end
end

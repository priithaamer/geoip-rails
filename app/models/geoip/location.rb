module Geoip
  class Location < Geoip::Base
    
    has_many :blocks
    
    def self.find_by_ip(ip)
      self.joins(:blocks).where('MBRCONTAINS(ip_poly, POINTFROMWKB(POINT(INET_ATON(?), 0)))', ip).first
    end
  end
end

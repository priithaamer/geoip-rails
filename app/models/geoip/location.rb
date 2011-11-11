module Geoip
  class Location < Geoip::Base
    
    IPADDR_REGEX = /^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$/
    
    has_many :blocks
    
    def self.find_by_ip(ip, &block)
      return nil unless IPADDR_REGEX.match(ip)
      
      location = self.joins(:blocks).where('MBRCONTAINS(ip_poly, POINTFROMWKB(POINT(INET_ATON(?), 0)))', ip).first
      
      if location and block_given?
        yield location
      else
        location
      end
    end
  end
end

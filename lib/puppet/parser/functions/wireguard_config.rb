#
# Accepts a part of wireguard config, adds IP and key there and
# returns output as a hash
#

module Puppet::Parser::Functions
  newfunction(:wireguard_config, :type => :rvalue, :doc => <<-EOS
    Generates configuration for wireguard client.
    EOS
  ) do |arguments|
    wireguard_config_hash = arguments[0]
    wireguard_peer_info = arguments[1]
    servername = arguments[2].to_str
    wg_interface = arguments[3].to_str
    wireguard_config_hash[ 'Interface' ][ 'Address' ] = wireguard_peer_info[ wg_interface ][ servername ][ 'Address' ]
    wireguard_config_hash[ 'Interface' ][ 'PrivateKey' ] = wireguard_peer_info[ wg_interface ][ servername ][ 'PrivateKey' ]
   
    return wireguard_config_hash
  
  end
end

# vim: set ts=2 sw=2 et :

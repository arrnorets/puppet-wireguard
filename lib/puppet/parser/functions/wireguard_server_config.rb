#
# Accepts a part of wireguard config, adds IP and key there and
# returns output as a hash
#

# [Interface]
# Address = 192.168.100.1/24
# PrivateKey = OKKosnAs63AV7lGKPOP6mW65yOMqixjG+Kg5ApMysHs=
# ListenPort = 32700
# 
# 
# # /* Peer list */
# 
# # // asg1-node2.asgardahost.ru
# [Peer]
# PublicKey = 1igDPrQpxvYEatm1+gBBjXK1kp8HXoRxEZMRKnTa30w=
# PersistentKeepalive = 10
# AllowedIPs = 192.168.100.2/32
# Endpoint = 89.163.242.28:32700
# 
# # /* END BLOCK */

module Puppet::Parser::Functions
  newfunction(:wireguard_server_config, :type => :rvalue, :doc => <<-EOS
    Generates configuration for wireguard server.
    EOS
  ) do |arguments|
    wireguard_config_hash = arguments[0]
    wireguard_peer_info = arguments[1]
    servername = arguments[2].to_str
    wg_interface = arguments[3].to_str

    wireguard_config_hash[ 'Interface' ][ 'Address' ] = wireguard_peer_info[ wg_interface ][ servername ][ 'Address' ]
    wireguard_config_hash[ 'Interface' ][ 'PrivateKey' ] = wireguard_peer_info[ wg_interface ][ servername ][ 'PrivateKey' ]

    wireguard_server_config = "[Interface]\n"

    wireguard_config_hash.each do |section, section_dict|
      
      if "#{section}" == 'Interface'
        section_dict.each do |key, value|
          wireguard_server_config = wireguard_server_config + "#{key}" + " = " + "#{value}" + "\n"
        end
      end

    end

    wireguard_server_config = wireguard_server_config + "\n\n # /* Peer list */ \n\n"    

    wireguard_peer_info[ wg_interface ].sort.each do |peer_name, peer_params_dict|
      
      if ( "#{peer_name}" != servername )
        wireguard_server_config = wireguard_server_config + "# // " + "#{peer_name}" + "\n[Peer]\n"
        peer_params_dict.each do |key, value|
          if ( "#{key}" == "Address" )
            wireguard_server_config = wireguard_server_config + "AllowedIPs = " + "#{value}".split('/')[0] + "/32" + "\n"
          elsif ( "#{key}" == "PrivateKey" )
            # Just skip it
          else
            wireguard_server_config = wireguard_server_config + "#{key}" + " = " + "#{value}" + "\n"
          end
        end
        wireguard_server_config = wireguard_server_config + "\n"
      end

    end

    wireguard_server_config = wireguard_server_config + "\n" + "# /* END BLOCK */" + "\n"

    return wireguard_server_config

  end
end

# vim: set ts=2 sw=2 et :

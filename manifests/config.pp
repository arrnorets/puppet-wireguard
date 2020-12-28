class wireguard::config ( $interface_configs, $is_interface_enabled, $wireguard_peer_info, $is_wireguard_server ) {

    $interfaces = keys( $interface_configs )
   
    # // If we have to configure a wireguard client

    if ( $is_wireguard_server != 'yes' ) {
        $interfaces.each | String $iface | {
            file { "/etc/wireguard/${iface}.conf":
                ensure => file,
                owner => root,
                group => root,
                mode => '0400',
                content => inline_template( hash2ini( wireguard_config( $interface_configs[$iface], $wireguard_peer_info, $fqdn, $iface ), " = ", true ) ),
                notify => Service[ "wg-quick@${iface}" ] 
            }
            service { "wg-quick@${iface}": 
                ensure => $is_interface_enabled,
                enable => $is_interface_enabled,
                provider => systemd,
                require => Class[ "wireguard::install" ],
            }
        }

    # // If we have to configure a wireguard server

    } else { 
        $interfaces.each | String $iface | {
            file { "/etc/wireguard/${iface}.conf":
                ensure => file,
                owner => root,
                group => root,
                mode => '0400',
                content => inline_template( wireguard_server_config( $interface_configs[$iface], $wireguard_peer_info, $fqdn, $iface ) ),
                notify => Service[ "wg-quick@${iface}" ]
            }
            service { "wg-quick@${iface}":
                ensure => $is_interface_enabled,
                enable => $is_interface_enabled,
                provider => systemd,
                require => Class[ "wireguard::install" ],
            }
        }
    }
}


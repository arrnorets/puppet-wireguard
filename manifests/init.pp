class wireguard {
    #Get all information about wireguard settings from Hiera using "hash" merging strategy.
    $hash_from_hiera = lookup('wireguard', { merge => 'deep' } ) 
    $wireguard_is_server = $hash_from_hiera['is_server'] ? { undef => 'false', default => $hash_from_hiera['is_server'] }
    $wireguard_config = $hash_from_hiera['config'] ? { undef => 'false', default => $hash_from_hiera['config'] }
    $wireguard_enable = $hash_from_hiera['enable'] ? { undef => 'false', default => $hash_from_hiera['enable'] }
    $is_dkms_needed_wg = $hash_from_hiera['is_dkms_needed'] ? { undef => 'yes', default => $hash_from_hiera['is_dkms_needed'] }
    $is_wireguard_server_value = $hash_from_hiera['is_wireguard_server'] ? { undef => 'no', default => $hash_from_hiera['is_wireguard_server'] } 
    $wireguard_peer_info_hash = lookup( 'wireguard_peer_info' ) 
    
    $wireguard_pkg_version = $hash_from_hiera['pkg_version'] ? { undef => 'present', default => $hash_from_hiera['config'] }
    class { "wireguard::install" :
        pkg_version => $wireguard_pkg_version,
	is_dkms_needed => $is_dkms_needed_wg
    }

    if ( $wireguard_config != false ) {
        class { "wireguard::config" :
            interface_configs => $wireguard_config,
            is_interface_enabled => $wireguard_enable,
	    wireguard_peer_info => $wireguard_peer_info_hash,
	    is_wireguard_server => $is_wireguard_server_value
        }
    }
    else {
        notify { "No config for server." : }
    }
}


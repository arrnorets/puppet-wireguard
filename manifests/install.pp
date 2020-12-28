class wireguard::install ( $pkg_version, $is_dkms_needed ) {
    
    if( $is_dkms_needed == 'no' ) {
        $wireguard_packages = [ "wireguard-tools" ]
    } else {
        $wireguard_packages = [ "wireguard-dkms", "wireguard-tools" ]
    }
    
    package { $wireguard_packages :
        ensure => $pkg_version,
    }
    
    file { "/etc/wireguard":
        ensure => directory,
	mode => '0700',
	owner => root,
	group => root,
    }
}

# Table of contents
1. [Common purpose](#1-common-purpose)
2. [Compatibility](#2-compatibility)
3. [Installation](#3-installation)
4. [Config example in Hiera and result files](#4-config-example-in-hiera-and-result-files)


# 1. Common purpose
Wireguard is a module for [wireguard](https://wireguard.com) config managing. Both client and server configs are supported.

# 2. Compatibility
This module was tested on CentOS 7. It also should work on Fedora 19 and higher and RHEL 7, but no tests were performed.

# 3. Installation
```puppetfile
mod 'wireguard',
    :git => 'https://github.com/arrnorets/puppet-wireguard.git',
    :ref => 'main'
```

# 4. Config example in Hiera and result files
This module follows the concept of so called "XaaH in Puppet". The principles are described [here](https://asgardahost.ru/library/syseng-guide/00-rules-and-conventions-while-working-with-software-and-tools/puppet-modules-organization/) and [here](https://asgardahost.ru/library/syseng-guide/00-rules-and-conventions-while-working-with-software-and-tools/3-hashes-in-hiera/).

Here is the example of config in Hiera:
```yaml
---
wireguard:
  package: 'present'
  enable: true
  is_dkms_needed: 'no'
  is_wireguard_server: 'no'
  config:
    wg0:
      Interface:
        Address: 'define_in_module'
        ListenPort: 32700
        PrivateKey: 'define_in_module'
      Peer:
        PublicKey: "< public key of host wg-server.local >"
        AllowedIPs: "10.10.10.0/24"
        Endpoint: "192.168.1.10:32700"
        PersistentKeepalive: 10


wireguard_peer_info:
  wg0:
    wg-server.local:
      Address: "10.10.10.1/24"
      PrivateKey: '< private key of host wg-server.local >'
      PublicKey: '< public key of host wg-server.local >'
      Endpoint: "192.168.1.10:32700"
      PersistentKeepalive: 10
    wg-client.local:
      Address: '10.10.10.2/24'
      PrivateeKey: '< private key of host wg-client.local >'
      PublicKey: '< public key of host wg-client.local >'
      Endpoint: '192.168.1.11:32700'
      PersistentKeepalive: 10
```
It will install wireguard-tools package, enable service wg-quick@wg0 and produce the folowing file /etc/wireguard/wg0.conf:
  + On client:
    ```bash
    [Interface]
    Address = 10.10.10.2/24
    ListenPort = 32700
    PrivateKey = < private key of host wg-client.local >
      
    [Peer]
    PublicKey = < public key of host wg-server.local >
    AllowedIPs = 10.10.10.0/24
    Endpoint = 192.168.11.10:32700
    PersistentKeepalive = 10
     ```
  - On server:
    ```bash
    [Interface]
    Address = 10.10.10.1/24
    ListenPort = 32700
    PrivateKey = < private key of host wg-server.local >
    
    
    # /* Peer list */ 
    
    # // wg-client.local
    [Peer]
    AllowedIPs = 10.10.10.2/32
    PublicKey = < public key of host wg-client.local >
    PersistentKeepalive = 10
    
    # /* END BLOCK */
    ```

network:
  version: 2
  renderer: NetworkManager
  ethernets:
    ens160:
      dhcp6: no
      addresses: [172.16.176.55/24]
      gateway4: 172.16.176.1
      nameservers:
        addresses: [10.0.102.50]
formatVersion: 1
inputs:
  name:
    type: string
    title: VM이름
  image:
    type: string
    title: VM 이미지
    enum:
      - vmw_ubuntu
      - vmw_centos8
      - vmw_ubuntu_02
  flavor:
    type: string
    title: VM 성능
  address:
    type: string
    title: IP 어드레스
#  address2:
#    type: string
#    title: IP 어드레스
resources:
  Cloud_Network_1:
    type: Cloud.Network
    properties:
      name: NET_${input.name}
      description: NET
      networkType: existing
      constraints:
        - tag: vmnet
  Cloud_Machine_1:
    type: Cloud.Machine
    properties:
      name: VM_${input.name}
      image: ${input.image}
      flavor: ${input.flavor}
      networks:
        - network: ${resource.Cloud_Network_1.id}
          assignment: static
          address: ${input.address}
      cloudConfig: |
        runcmd:
          - useradd koo3
          - yum update
          - yum install -y httpd
          - systemctl start httpd
          - systemctl stop firewalld

formatVersion: 1
inputs:
  name:
    type: string
    title: 이름
resources:
  net:
    type: Cloud.NSX.Network
    properties:
      networkType: existing
      constraints:
        - tag: nsx:seg
  Cloud_NSX_LoadBalancer_2:
    type: Cloud.NSX.LoadBalancer
    dependsOn:
      - net
    properties:
      routes:
        - protocol: HTTP
          port: 80
      network: ${net.name}
      instances:
        - ${resource.Cloud_vSphere_Machine_1.id}
        - ${resource.Cloud_vSphere_Machine_4.id}
  Cloud_vSphere_Machine_1:
    type: Cloud.vSphere.Machine
    properties:
      image: vmw_ubuntu
      cpuCount: 1
      totalMemoryMB: 1024
      networks:
        - network: ${resource.net.id}
          assignment: static
          address: 5.5.5.15
  Cloud_vSphere_Machine_4:
    type: Cloud.vSphere.Machine
    properties:
      image: vmw_ubuntu
      cpuCount: 1
      totalMemoryMB: 1024
      networks:
        - network: ${resource.net.id}
          assignment: static
          address: 5.5.5.16
  Cloud_NSX_LoadBalancer_1:
    type: Cloud.NSX.LoadBalancer
    dependsOn:
      - net
    properties:
      routes:
        - protocol: HTTP
          port: 80
      network: ${net.name}
      instances:
        - ${resource.Cloud_vSphere_Machine_3.id}
        - ${resource.Cloud_vSphere_Machine_2.id}
  Cloud_vSphere_Machine_3:
    type: Cloud.vSphere.Machine
    properties:
      image: vmw_ubuntu
      cpuCount: 1
      totalMemoryMB: 1024
      networks:
        - network: ${resource.net.id}
          assignment: static
          address: 5.5.5.17
  Cloud_vSphere_Machine_2:
    type: Cloud.vSphere.Machine
    properties:
      image: vmw_ubuntu
      cpuCount: 1
      totalMemoryMB: 1024
      networks:
        - network: ${resource.net.id}
          assignment: static
          address: 5.5.5.18

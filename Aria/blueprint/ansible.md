formatVersion: 1
inputs:
  address:
    type: string
    title: IP 어드레스
resources:
  Cloud_Network_1:
    type: Cloud.Network
    properties:
      networkType: existing
      constraints:
        - tag: vmnet
  Cloud_Machine_1:
    type: Cloud.Machine
    properties:
      image: vmw_ubuntu
      flavor: small
      networks:
        - network: ${resource.Cloud_Network_1.id}
          assignment: static
          address: ${input.address}
  Cloud_Ansible_1:
    type: Cloud.Ansible
    properties:
      host: ${resource.Cloud_Machine_1.*}
      osType: linux
      account: ansible
      username: mzc
      password: megazone00!
      inventoryFile: /opt/inventory/${env.deploymentId}/hosts
      playbooks:
        provision:
          - /opt/playbook/test.yaml

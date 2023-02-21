# 1. Deepops (ansible kubespray 클러스터 자동화 )


### 1-1.git clone
```
$ git clone https://github.com/NVIDIA/deepops.git
```
### 1-2.script 돌리기 ansible 설치 및 Galaxy role 업데이트
```
$ ./deepops/scripts/setup.sh
# source /opt/deepops/env/bin/activate ( 파이썬 가상환경 들어가기 )
```

### 1-3./config/inventory 수정 ( cluster 구성 master,worker ip set )
- config.example -> config로 변경


### 1-4. 실행 명령
```
$ ansible-playbook -l k8s-cluster playbooks/k8s-cluster.yml
```
- issue 01. master01 >= 앤서블 호스트 (memory)
- issue 02. private key 있을경우 주석처리 (deepops/playbooks/bootstrap/bootsrap-ssh.yml)
```

    - name: Add SSH public key to ansible user authorized keys
      authorized_key:
        user: "{{ ansible_env.SUDO_USER | default(ansible_env.USER) }}"
        state: present
        key: "{{ lookup('file', private_key + '.pub') }}"
      tags: ssh-public
```

# 2. Nvidia operator 설치 
https://docs.nvidia.com/networking/pages/releaseview.action?pageId=39266293

- GPU operatior
- SR-IOV network operator : GPU 가속 및 kubernetes GPU 할당




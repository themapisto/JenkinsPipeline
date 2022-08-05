
### 1.git clone
```
$ git clone https://github.com/NVIDIA/deepops.git
```
### 2.script 돌리기 ansible 설치 및 Galaxy role 업데이트
```
$ ./deepops/scripts/setup.sh
# source /opt/deepops/env/bin/activate ( 파이썬 가상환경 들어가기 )
```

### 3./config/inventory 수정 ( cluster 구성 master,worker ip set )
- config.example -> config로 변경


### 4. 실행 명령
```
$ ansible-playbook -l k8s-cluster playbooks/k8s-cluster.yml
```
- issue 01. master01 >= 앤서블 호스트 (memory)
- issue 02. private key 있을경우 주석처리


# 0. harbor provision with Helm
# 삼성 무선사 프로젝트 harbor 구축시 작업내용

## Prerequisites
- High available ingress controller - nginx contorller 
- RWX(ReadWriteMany)형태의 데이터 공유가 가능한 PVC (WekaFS)
  *** mount 된 pvc와 연동된 디렉터리의 권한 조정 chmod 777 로 우선 처리함 ( 추후 필요한 권한에 맞게 설정) 
- contianerd proxy options



## 작업순서
- 1. helm chart 다운로드 후 수정
- 2. values.yaml 수정
- 3. helm install
- 4. containerd insecure option 설정 ( 각 노드별 /etc/containerd/config.toml 세팅 )



### 1-1. helm 설치
### 1-2. helm chart registry 추가

```
http_proxy=<your proxy> Helm repo add harbor/harbor
```

### 1-3. harbor chart 설정 파일 다운로드 및 수정
```
$ mkdir -p ~/install/goharbor && cd ~/install/goharbor
$ helm inspect values harbor/harbor > values.yaml
$ vi values.yaml
```

### 2-1. values.yml 수정
- root home 디렉터리의 /install/goharbor

```
1. ingress 
- ingress.tls.enabled = false
- ingress.hosts.core = n3-repo.spcinfra.cloud
- ingress.hosts.notary = n3-repo-n.spcinfra.cloud

2. externalUrl = http://n3-repo.spcinfra.cloud

3. persistence
- persistence.persistentVolumeClam.registry/chartmuseum/jobservice/database/redis/trivy.storageClass = "storageclass-n3-spcp-repo"
```

### 3-1. helm install
- root home directory의 /install/goharbor
```
helm install harbor -f values.yml -n harbor harbor/harbor
```

### 4-1. /etc/containerd/config.toml

```
[plugins."io.containerd.grpc.v1.cri".registry.mirrors."ingress의 도메인"]
  endpoint = ["https://인그레스의 도메인"]

[plugins."io.containerd.grpc.v1.cri".registry.configs."인그레스의 도메인".tls]
  insecure_skip_verify = true

[plugins."io.containerd.grpc.v1.cri".registry.configs."인그레스의 도메인".auth]
  username = "admin"
  password = "1qsz2wsx"

```

### 4-2. containerd 재시작

systemctl restart containerd



### 5-1. docker demon 설치 후 테스트

vi /etc/docker/daemon.json
```
{
  "insecure-registries": ["인그레스의 도메인"]
}
```
systemctl restart docker 

docker login -u {{인그레스의 도메인}}



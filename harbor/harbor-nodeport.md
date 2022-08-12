# 절차 : Helm 설치를 통한 Harbor 노드포트 구성
## 1. 요구조건
### 1-1. StorageClass와 PVC 연동을 통한 Dynamic Provisioning Storage 세팅


### 1-1-1. aws-ebs를 storageclass로 선언할 경우
- https://happycloud-lee.tistory.com/165
- https://jwher.github.io/posts/install-harbor/


```
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: aws-sc-ebs
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp2
  fsType: ext4
```

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: aws-sc-ebs-pvc
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  storageClassName: aws-sc-ebs
```
### 1-1-2. local Storage를 수동으로 PV 생성하여 구성할경우
https://lapee79.github.io/article/use-a-local-disk-by-local-volume-static-provisioner-in-kubernetes/
- pv 를 4(4개 만들어줘야함)
- 각 노드별 공유 directory 생성

```
cat << EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: test-local-pv
spec:
  capacity:
    storage: 10Gi
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: local-storage
  local:
    path: /data/volumes/pv1
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - gpu01
          - mgmt01
          - mgmt02
          - mgmt03
EOF
```

```
cat << EOF | kubectl apply -f -
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: test-pvc
spec:
  accessModes:
  - ReadWriteOnce
  storageClassName: local-storage
  resources:
    requests:
      storage: 10Gi
EOF
```




### 1-2. helm 설치
### 1-3. helm chart registry 추가
### 1-4. harbor chart 설정 파일 다운로드 및 수정
```
$ mkdir -p ~/install/harbor-k8s && cd ~/install/harbor-k8s
$ helm inspect values bitnami/harbor > values.yaml
$ vi values.yaml
```

## 2. Harbor 설치 전 config ( values.yaml 수정 )
```
externalURL: https://myharbor.io 

harborAdminPassword: "VMware1!"

## Service parameters
##
service:
  ## @param service.type The way how to expose the service: `Ingress`, `ClusterIP`, `NodePort` or `LoadBalancer`
  ##
  type: NodePort
  ## TLS parameters
  ##
  tls:
    commonName: 'myharbor.io' 

## Ingress parameters
##
ingress:
  ## @param ingress.enabled Deploy ingress rules
  ##
  enabled: true 

  hosts:
    core: myharbor.io  
    notary: notary.myharbor.io  

persistence:
  ## @param persistence.enabled Enable the data persistence or not
  ##
  enabled: true

  persistentVolumeClaim:
    registry:
      storageClass: "aws-sc-ebs" 
      subPath: ""
      accessMode: ReadWriteOnce
      size: 5Gi
    jobservice:
      storageClass: "aws-sc-ebs" 
      subPath: ""
      accessMode: ReadWriteOnce
      size: 1Gi
    chartmuseum:
      storageClass: "aws-sc-ebs" 
      subPath: ""
      accessMode: ReadWriteOnce
      size: 5Gi
    trivy:
      storageClass: "aws-sc-ebs" 
      accessMode: ReadWriteOnce
      size: 5Gi
```      

## 3. Harbor 설치 
```
helm install harbor -f values.yaml bitnami/harbor -n harbor

(변경 할때는 아래 명령어)
helm upgrade harbor -f values.yaml bitnami/harbor -n harbor

```

## 4. containerd insecure_registry 옵션 설정
### 4-1. /etc/containerd/config.toml 파일 수정
```
[root@node1 ~]# cat /etc/containerd/config.toml
# 다른 설정들과 동일하게 containerd도 /etc/ 밑에 설정 파일이 있다.

[plugins.cri.registry.configs."core.harbor.domain:32120".tls]
  insecure_skip_verify = true

[plugins.cri.registry.configs."core.harbor.domain:32120".auth]
   username = "admin"
   password = "VMware1!"
```
### 4-2. containerd 재시작
```
[root@node1 ~]# systemctl restart containerd
```

### 4-3. 검증
```
$ helm delete harbor -n harbor
$ kubectl delete pvc --all -n harbor
$ helm install harbor -f values.yaml bitnami/harbor -n harbor


Prerequisites
- Kubernetes cluster 1.10+
- Helm 2.8.0+
- 헬름으로 배포하면 여러 pvc가 생성되며, 약 16GB 정도의 pv를 생성할 수 있어야함

helm repo add bitnami https://charts.bitnami.com/bitnami

mkdir -p ~/install/harbor-k8s && cd ~/install/harbor-k8s
helm inspect values bitnami/harbor > values.yaml
vi values.yaml

values.yaml에서 값 변경
- externalURL: https://core.harbor.domain:30300
- harborAdminPassword: "        "
- type: NodePort
- nodePorts: http 30301, https 30300
- persistentVolumeClaim의 storageClass: "        "

kubectl create ns harbor
  
helm install harbor -f values.yaml bitnami/harbor -n harbor

harbor service https(443) 노드포트로 접속
- ID: admin
- PW: values.yaml 파일 참고



# 컨테이너 런타임 도커 사용시
참고 https://krksap.tistory.com/1919

harbor 프로젝트 생성 

vi /etc/hosts
- 서버 주소 core.harbor.domain

vi /etc/docker/daemon.json
- {
  "insecure-registries": ["core.harbor.domain:30003"]
}

systemctl restart docker 

docker login -u admin core.harbor.domain:30003
docker build -t core.harbor.domain:30003/프로젝트명/이미지명:태그 .
docker push core.harbor.domain:30003/프로젝트명/이미지명:태그


#### 컨테이너 런타임 containerd 사용시 

http 사용을 위한 insecure 설정
containerd config.toml 내용 추가

[plugins."io.containerd.grpc.v1.cri".registry.mirrors."core.harbor.domain:30300"]
  endpoint = ["https://core.harbor.domain:30003"]

[plugins."io.containerd.grpc.v1.cri".registry.configs."core.harbor.domain:30300".tls]
  insecure_skip_verify = true

[plugins."io.containerd.grpc.v1.cri".registry.configs."core.harbor.domain:30300".auth]
  username = "admin"
  password = "         "

systemctl restart containerd


```


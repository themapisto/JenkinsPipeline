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
[plugins.cri.registry]
[plugins.cri.registry.mirrors]
[plugins.cri.registry.mirrors."docker.io"]
  endpoint = ["https://mirror.gcr.io","https://registry-1.docker.io","https://harbor.spk.io"]
[plugins.cri.registry.configs."harbor.spk.io".tls]
  insecure_skip_verify = true
# mirrors 설정은 굳이 필요 없기는 하다. 도커 허브(docker.io) 이미지를 2번째 pull 부터는 내부 private registry 에서 가져오겠다는 설정이다.

```
### 4-2. containerd 재시작
```
[root@node1 ~]# systemctl restart containerd
```

### 4-3. 검증
```
$ crictl pull harbor.aikoo.net/tanzu/nginx:0.1
$ crictl images

```


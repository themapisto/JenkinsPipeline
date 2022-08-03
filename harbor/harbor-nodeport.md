# 절차 : Helm 설치를 통한 Harbor 노드포트 구성
## 1. 요구조건
- StorageClass와 PVC 연동을 통한 Dynamic Provisioning Storage 세팅

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
- 1) helm 설치
- 2) helm chart registry 추가
- 3) harbor chart 설정 파일 다운로드 및 수정

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
      storageClass: "nfs-standard" 
      subPath: ""
      accessMode: ReadWriteOnce
      size: 5Gi
    jobservice:
      storageClass: "nfs-standard" 
      subPath: ""
      accessMode: ReadWriteOnce
      size: 1Gi
    chartmuseum:
      storageClass: "nfs-standard" 
      subPath: ""
      accessMode: ReadWriteOnce
      size: 5Gi
    trivy:
      storageClass: "nfs-standard" 
      accessMode: ReadWriteOnce
      size: 5Gi
```      

## 3. Harbor 설치 
```
helm install harbor -f values.yaml bitnami/harbor -n harbor

(변경 할때는 아래 명령어)
helm upgrade harbor -f values.yaml bitnami/harbor -n harbor

```

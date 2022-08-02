# 0. harbor-ha provision with Helm

## Prerequisites
- High available ingress controller
- RWX(ReadWriteMany)형태의 데이터 공유가 가능한 PVC (NFS, Object Storage)
- 외부 HA 구성의 PostgreSQL database
- 외부 HA 구성의 Redis


## 1. Cluster 구성의 Redis 생성
```
$ kubectl create ns harbor
$ sudo snap install helm --classic
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm repo update

# 설치 가능한 Redis 확인
$ helm search repo bitnami/redis --versions

# Source Code Download
$ helm pull bitnami/redis --version=16.8.4 --untar

# Storage Node를 사용하기 위해 Affinity 사용
$ cat affinity-values.yaml
redis:
  affinity:
   nodeAffinity:
     requiredDuringSchedulingIgnoredDuringExecution:
       nodeSelectorTerms:
       - matchExpressions:
         - key: node-type
           operator: NotIn
           values:
           - "router"
           - "controlpalne"
  nodeSelector:
    node-type: "storage"
    
updateJob:
  affinity:
   nodeAffinity:
     requiredDuringSchedulingIgnoredDuringExecution:
       nodeSelectorTerms:
       - matchExpressions:
         - key: node-type
           operator: NotIn
           values:
           - "router"
           - "controlpalne"
  nodeSelector:
    node-type: "storage"

# value.yaml에 아래 라인 변경 (3개)
  accessModes:
    - ReadWriteMany


# Reids Sentinal Install
# sentinel.downAfterMilliseconds=5000 <<< 조금 더 빠르게 Master의 Down을 감지 할 경우 설정 변경 필요, Default 60s
$ helm upgrade --install redis . --namespace harbor \
--set global.storageClass=gp2 \
--set sentinel.enabled=true \
--set global.redis.password="1q2w3e4r5t" \
--set auth.sentinel=false \
-f values.yaml,affinity-values.yaml

삭제 방법
$ helm delete redis -n harbor




# Pod 형상 확인
$ kubectl -n harbor get pods
NAME              READY   STATUS    RESTARTS   AGE
redis-node-0                            2/2     Running   0          14m
redis-node-1                            2/2     Running   0          13m
redis-node-2                            2/2     Running   0          12m

# Reids Password 확인
$ kubectl get secret --namespace harbor redis -o jsonpath="{.data.redis-password}" | base64 --decode
```

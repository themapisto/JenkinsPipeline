# 1. TAP 서비스 바인딩
## Prerequisite
- 탭 1.4.0 버전 설치 (cluster with Tanzu Application Platform installed.)
- Tanzu CLI 및 해당 플러그인을 설치
- VMware Tanzu RabbitMQ for Kubernetes.
- VMware Tanzu SQL with Postgres for Kubernetes.
- VMware Tanzu SQL with MySQL for Kubernetes.

## 참고사항
위 VMware에서 제공하는 Tanzu RabbitMQ, Postgres, Mysql은 kapp으로 퍼블릭 깃헙의 소스를 통해  설치 하지만,
고객사 상황에 맞게 프라이빗으로 구성할수 있다. 설치 과정은 다음과 같다.


## 설치 절차

### Set up a Service

1.kapp install ( RabbitMQ Cluster Operator 설치 )
```
kapp -y deploy --app rmq-operator --file https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml
```

<br><br>
2.RBAC 설정
```
# rmq-reader-for-binding-and-claims.yaml
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: rmq-reader-for-binding-and-claims
  labels:
    servicebinding.io/controller: "true"
rules:
- apiGroups: ["rabbitmq.com"]
  resources: ["rabbitmqclusters"]
  verbs: ["get", "list", "watch"]
  
$ kubectl apply -f rmq-reader-for-binding-and-claims.yaml
  
```
<br><br>
3.ClusterInstanceClass 생성
```
# rmq-class.yaml
---
apiVersion: services.apps.tanzu.vmware.com/v1alpha1
kind: ClusterInstanceClass
metadata:
  name: rabbitmq
spec:
  description:
    short: It's a RabbitMQ cluster!
  pool:
    group: rabbitmq.com
    kind: RabbitmqCluster
# for Postgres
#   group: sql.tanzu.vmware.com
#   kind: Postgres
# for MySql
#   group: with.sql.tanzu.vmware.com
#   kind: MySQL

$ kubectl apply -f rmq-class.yaml

```
<br><br>

### Create a Service instance

1.namespace 생성
```
kubectl create namespace service-instances
```
<br><br>
2.Rabbitmq Cluster 생성
```
# rmq-1-service-instance.yaml
---
apiVersion: rabbitmq.com/v1beta1
kind: RabbitmqCluster
metadata:
  name: rmq-1
  namespace: service-instances
  
$ kubectl apply -f rmq-1-service-instance.yaml  
```
<br><br>
3.resourceClaimPolicy 생성
```
# rmq-claim-policy.yaml
---
apiVersion: services.apps.tanzu.vmware.com/v1alpha1
kind: ResourceClaimPolicy
metadata:
  name: rabbitmqcluster-cross-namespace
  namespace: service-instances
spec:
  consumingNamespaces:
  - '*'
  subject:
    group: rabbitmq.com
    kind: RabbitmqCluster
# for Postgres
#   group: sql.tanzu.vmware.com
#   kind: Postgres
# for MySql
#   group: with.sql.tanzu.vmware.com
#   kind: MySQL

$ kubectl apply -f rmq-claim-policy.yaml

```

### Claim a service instance

1. 서비스 인스턴스 요청
```
$ tanzu service class list
$ tanzu service class-claim create rmq-1 --class rabbitmq
```




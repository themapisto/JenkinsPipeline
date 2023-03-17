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

> 1. Set up a Service
1-1.kapp RabbitMQ 클러스터 쿠버네티스 오퍼레이터 install
1-2.RBAC 설정
1-3.ClusterInstanceClass 생성

> 2. Create a Service instance
2-1.namespace 생성
2-2.Rabbitmq Cluster 생성
2-3.resourceClaimPolicy 생성

> 3. Claim a service instance
3-1. 서비스 인스턴스를 요청



### 스크립트 참고

```
kapp -y deploy --app rmq-operator --file https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml
```

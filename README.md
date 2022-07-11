##  🍎 CICD 파이프라인 만들기

| Week | 작업 |블로그|커리큘럼 내용 |
| ------ | -- | -- |----------- |
| 1주차 | ☑️ | ☑️ | Harbor 구축 / Https 인증서 생성 및 확인  |
| 2주차 | ☑️ | ☑️ | Jenkins 구축 |
| 3주차 | ☑️ | ☑️ | Kubernetes 클러스터 구축 |
| 4주차 | ☑️ | ☑️ | Harbor Jenkins 연동 |
| 5주차 |  |  | Kubernetes Private Regisry 사용 방안 |
| 6주차 |  |  | MSA 어플리케이션 만들어보기  |
| 7주차 |  |  | Ingress 룰 만들어보기 |
| 8주차 |  |  | Monitoring 및 로깅 대시보드 만들기 |

# 1주차
## 1-1. Harbor 구축
```
wget https://tas-koo.s3.ap-northeast-1.amazonaws.com/koo/harbor-setup.sh
sh harbor-setup.sh

```
## 1.2. harbor.yml 수정 : domain name, CA cert path 수정





### 별첨.  docker secret을 쿠버네티스 secret으로 등록

```
$ kubectl create secret generic regcred \
--from-file=.dockerconfigjson=/home/ubuntu/.docker/config.json \
--type=kubernetes.io/dockerconfigjson

```

### 별첨. aws cli 설치
```
$ sudo apt install awscli

```
### . aws cp
```
$ aws s3 cp harbor-setup.sh s3://tas-koo/koo/

```




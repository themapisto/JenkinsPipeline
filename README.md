<img src="https://img.shields.io/badge/이름-색상코드?style=flat-square&logo=로고명&logoColor=로고색"/>

1. docker secret을 쿠버네티스 secret으로 등록

kubectl create secret generic regcred \
--from-file=.dockerconfigjson=/home/ubuntu/.docker/config.json \
--type=kubernetes.io/dockerconfigjson


2. 배포하는 test.yaml을 배포
3. git config 등록



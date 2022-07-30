## 1-1. Harbor 구축
```
wget https://tas-koo.s3.ap-northeast-1.amazonaws.com/koo/harbor-setup.sh

해당 shell은 harbor 설치 후 harbor config까지 바꿔줌
- harbor.yml 수정 : domain name, CA cert path 수정


sh harbor-setup.sh

```

@ 2주차
## 1.2. harbor 사설인증서 sign
```
wget https://tas-koo.s3.ap-northeast-1.amazonaws.com/koo/harbor-cert-shell.zip

# 해당 zip파일은 harbor 사설 인증서를 openssl을 이용해 만드는 shellscript이다.

```

## 1.3. docker pull, tag, push
```
ubuntu@ip-172-31-16-109:~$ docker tag nginx harbor.aikoo.net/tanzu/nginx:1
ubuntu@ip-172-31-16-109:~$ docker push harbor.aikoo.net/tanzu/nginx:1

```



## 별첨.  docker secret을 쿠버네티스 secret으로 등록

```
$ kubectl create secret generic testkoo \
--from-file=.dockerconfigjson=/home/ubuntu/.docker/config.json \
--type=kubernetes.io/dockerconfigjson

```

### aws cli 설치
#### - aws configure 을 통해 IAM 계정을 연동한다
```
$ sudo apt install awscli
$ aws configure
$ aws eks update-kubeconfig --region us-east-2 --name education-eks-IKJITuQB
 
```
###  kubectl 설치 
```
   $  curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.23.6/bin/linux/amd64/kubectl
   $  chmod +x ./kubectl
   $  sudo mv ./kubectl /usr/local/bin/kubectl
```


###  aws s3에 업로드, 다운로드
```
$ aws s3 cp harbor-setup.sh s3://tas-koo/koo/ ( 업로드 )
$ wget https://tas-koo.s3.ap-northeast-1.amazonaws.com/koo/harbor-setup.sh ( 다운로드 )
```





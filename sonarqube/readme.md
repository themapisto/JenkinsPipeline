1. SonarQube를 helm으로 설치해보려 했지만 잘 안되서 
  VM에 docker을 설치한 후에 노드포트로 직접 사용했다.




2. SonarQube 이미지 설치하기
Docker 설치가 완료됐다면 이제 SonarQube 이미지를 가져오면 됩니다. Docker Hub에서 SonarQube의 이미지를 가져와서 설치합니다.

```
docker pull sonarqube
```

명령어 한 줄로 sonarqube의 설치는 끝이 납니다! (역시 Docker 🤩)

이미지가 잘 설치되었는지는 아래의 명령어를 통해 확인할 수 있습니다.

3. 확인
```
docker images
```

SonarQube가 정상적으로 설치됨을 확인할 수 있습니다.

SonarQube 실행하기
이제 Docker로 설치한 SonarQube를 실행해보겠습니다.

4. docker 포트 노출

```
docker run -d --name sonarqube -p 5000:9000 sonarqube
```



-p : 컨테이너의 포트를 호스트의 포트와 바인딩해 연결할 수 있다. -p [host(외부)의 port]:[container(내부)의 port] 이다.

SonarQube의 경우 기본이 9000 포트입니다. 저는 5000포트로 연결햇습니다.


처음 접속하면 로그인을 해야하는데 기본 ID와 비밀번호는 모두 admin입니다. 이를 통해 접속하면 아래와 같은 페이지를 볼 수 있습니다.


5. sonarqube token 발행
```
squ_892cd416be91411e1e25b99cf8d1f37ff33af727
```


6. java 11 version 설치


7. gradle을 통해 프로젝트 등록
```
./gradlew sonarqube \          
  -Dsonar.projectKey=Koo \
  -Dsonar.host.url=http://54.238.193.86:5000 \
  -Dsonar.login=squ_892cd416be91411e1e25b99cf8d1f37ff33af727
  
```

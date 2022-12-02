##  🍎 CICD 파이프라인 만들기

| Week | 작업 |블로그|커리큘럼 내용 |
| ------ | -- | -- |----------- |
| 1주차 | ☑️ | ☑️ | Harbor 구축 / Https 인증서 생성 및 확인  |
| 2주차 | ☑️ | ☑️ | Harbor HA (helm) 설치 |
| 3주차 | ☑️ | ☑️ | Rancher with Harbor 테스트|
| 4주차 | ☑️ | ☑️ | Helm Deep dive |

## github cmp ##
```
git add . git commit -m git push를 동시에 적용하는 세팅
$ git config --global alias.cmp '!f() { git add -A && git commit -m "$@" && git push; }; f'
```

## github username , password 저장
```
$ git config --global credential.helper store
```

## github 계정 저장
```
git config --global user.name "themapisto"
git config --global user.email "themapisto@naver.com"
```

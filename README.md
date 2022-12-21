docker tag "원래 이미지" harbor.aikoo.net/tanzu/"새로운 이미지명"

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

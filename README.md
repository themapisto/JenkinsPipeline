##  🍎 iOS 커리큘럼

| Week | 세미나 | 과제 |커리큘럼 내용 |
| ------ | -- | -- |----------- |
| 1주차 | ☑️ | ☑️ | iOS 기초, H.I.G를 통한 컴포넌트의 이해, 화면 전환 |
| 2주차 | ☑️ | ☑️ | Autolayout을 통한 기초 UI구성, Scroll View의 이해 |
| 3주차 | ☑️ | ☑️ | TableView, CollectionView, 데이터 전달 방식 |
| 4주차 | ☑️ | ☑️ | Cocoapods & Networking + 솝커톤 전 보충 세미나 |
| 5주차 |  |  |디자인 합동 세미나 |
| 6주차 |  |  |서버 합동 세미나 + 솝커톤  |
| 7주차 |  |  |클론 코딩을 통한 실전 UI 구성, Animation, 통신 보충  |
| 8주차 |  |  |e기획 경선 + 앱잼 전 보충 세미나 + 앱스토어 배포 가이드  |


1. docker secret을 쿠버네티스 secret으로 등록

kubectl create secret generic regcred \
--from-file=.dockerconfigjson=/home/ubuntu/.docker/config.json \
--type=kubernetes.io/dockerconfigjson


2. 배포하는 test.yaml을 배포
3. git config 등록



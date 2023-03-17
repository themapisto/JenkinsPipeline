# 1. TAP 서비스 바인딩 ( Developer )
## Prerequisite
- Set up a service
- Created a service instance
- Claimed the service instance

***
<center><img src="img.png" width="70%" height="70%"></center>
***

### Claimed 된 서비스 인스턴스 확인

```
tanzu services class-claims list
-------------------------------------
  NAME      CLASS     READY  REASON
  rmq-1     rabbitmq  True   Ready
  
tanzu services class-claims get rmq-1
--------------------------------------  
Name: rmq-1
Namespace: default
Claim Reference: services.apps.tanzu.vmware.com/v1alpha1:ClassClaim:rmq-1
Class Reference:
  Name: rabbitmq
Status:
  Ready: True
  Claimed Resource:
    Name: rmq-1
    Namespace: service-instances
    Group: rabbitmq.com
    Version: v1beta1
    Kind: RabbitmqCluster  
```

### 워크로드 생성
```
tanzu apps workload create spring-sensors-consumer-web \
  --git-repo https://github.com/tanzu-end-to-end/spring-sensors \
  --git-branch rabbit \
  --type web \
  --label app.kubernetes.io/part-of=spring-sensors \
  --annotation autoscaling.knative.dev/minScale=1 \
  --service-ref="rmq=services.apps.tanzu.vmware.com/v1alpha1:ClassClaim:rmq-1"

tanzu apps workload create \
  spring-sensors-producer \
  --git-repo https://github.com/tanzu-end-to-end/spring-sensors-sensor \
  --git-branch main \
  --type web \
  --label app.kubernetes.io/part-of=spring-sensors \
  --annotation autoscaling.knative.dev/minScale=1 \
  --service-ref="rmq=services.apps.tanzu.vmware.com/v1alpha1:ClassClaim:rmq-1"
```


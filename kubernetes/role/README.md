## kubeadm default-token

TOKEN=$(kubectl describe secret default-token | grep -E '^token' | cut -f2 -d':' | tr -d " "&)


## test 
kubectl get services --as system:serviceaccount:default:ehdrms2034

### 부여받지 않은 권한 사용하면 안됨
kubectl get deployment --as system:serviceaccount:default:ehdrms2034

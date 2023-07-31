# SCP ec2 to local
# SCP VM to local

scp -i /Users/mzc01-kook/Downloads/koo-tas.pem ubuntu@18.178.214.128:/home/ubuntu/ca-certificates.crt ~/
scp mzc@10.20.4.105:/home/mzc/Downloads/helm-charts/charts/prometheus/values.yaml ~/


# SCP local to ec2

scp kube-apiserver.yaml  kube-controller-manager.yaml  kube-scheduler.yaml root@10.20.4.105:/etc/kubernetes/manifests/
scp -i test.pem -r testfiles ec-user@10.0.0.0:/home/ec2-user
scp -i /Users/mzc01-kook/Downloads/koo-tas.pem -r Downloads/파일이름 ubuntu@IP:/경로

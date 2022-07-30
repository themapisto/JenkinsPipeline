# harbor-ha provision with Helm

## Prerequisites
- High available ingress controller
- 외부 HA 구성의 PostgreSQL database
- 외부 HA 구성의 Redis
- RWX(ReadWriteMany)형태의 데이터 공유가 가능한 PVC (NFS, Object Storage)

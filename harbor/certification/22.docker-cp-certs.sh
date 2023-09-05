#! /bin/bash

HARBOR_SVR=harbor.mzc.local
SERVER_KEY=ncc.key
SERVER_CRT=ncc.crt
SERVER_CERT=ncc.cert
CA_CRT=ca-git.crt

sudo mkdir -p /etc/docker/certs.d/$HARBOR_SVR
sudo cp $SERVER_KEY /etc/docker/certs.d/$HARBOR_SVR
sudo cp $SERVER_CRT /etc/docker/certs.d/$HARBOR_SVR
sudo cp $SERVER_CERT /etc/docker/certs.d/$HARBOR_SVR
sudo cp $CA_CRT /etc/docker/certs.d/$HARBOR_SVR

# sudo systemctl restart docker

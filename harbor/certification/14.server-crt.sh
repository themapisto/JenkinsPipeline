# pass phrase: Megazone00!
sudo openssl x509 -req -days 3650 -extensions v3_user -in ncc.csr -CA ca-git.crt -CAcreateserial -CAkey ca-git.key -extfile 13.server.conf -out ncc.crt

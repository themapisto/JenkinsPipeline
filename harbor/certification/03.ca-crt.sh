# pass phrase: Megazone00!
sudo openssl x509 -req -days 3650 -extensions v3_ca -set_serial 1 -signkey ca-git.key -in ca-git.csr -extfile 02.ca-git.conf -out ca-git.crt

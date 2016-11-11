#!/usr/bin/env bash
PASSWORD=secret

openssl genrsa -aes256 -passout pass:$PASSWORD -out ca-key.pem 2048
openssl req -new -x509 -days 365 -key ca-key.pem -sha256  -passin pass:$PASSWORD -subj "/C=FR/O=ACME/CN=docker-ca" -out ca.pem

openssl genrsa -out server-key.pem 2048
openssl req -subj "/CN=$(hostname -i)" -sha256 -new -key server-key.pem -out server.csr
echo subjectAltName = IP:$(hostname -i),IP:127.0.0.1 > extfile.cnf
openssl x509 -req -days 365 -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -extfile extfile.cnf -passin pass:$PASSWORD


openssl genrsa -out client-key.pem 2048
openssl req -subj '/CN=client' -new -key client-key.pem -out client.csr
echo extendedKeyUsage = clientAuth > client-extfile.cnf
openssl x509 -req -days 365 -in client.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out client-cert.pem -extfile client-extfile.cnf -passin pass:$PASSWORD

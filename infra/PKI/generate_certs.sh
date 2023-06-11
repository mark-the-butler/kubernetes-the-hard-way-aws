#!/bin/bash

# Generate CA Certs
cfssl gencert -initca ca-csr.json | cfssljson -bare ca

# Generate Admin User Certs
cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  admin-csr.json | cfssljson -bare admin

  # 

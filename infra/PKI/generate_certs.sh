#!/bin/bash

worker_ips=$1
static_ip=$2

worker_names=("worker-0" "worker-1" "worker-2")

# Generate CA Certs
cfssl gencert -initca ./PKI/ca-csr.json | cfssljson -bare ca

# Generate Admin User Certs
cfssl gencert \
    -ca=./PKI/ca.pem \
    -ca-key=./PKI/ca-key.pem \
    -config=./PKI/ca-config.json \
    -profile=kubernetes \
    ./PKI/admin-csr.json | cfssljson -bare admin

# Generate Client Certs
for worker in ${worker_names[@]}; do
    public_ip=$(echo $worker_ips | jq '."'$worker'".public_ip')
    private_ip=$(echo $worker_ips | jq '."'$worker'".private_ip')

    cfssl gencert \
        -ca=./PKI/ca.pem \
        -ca-key=./PKI/ca-key.pem \
        -config=./PKI/ca-config.json \
        -hostname=${worker},${public_ip},${private_ip} \
        -profile=kubernetes \
        ./PKI/${worker}-csr.json | cfssljson -bare ${worker}
done

Generate Kube Controller Manager Cert
cfssl gencert \
    -ca=./PKI/ca.pem \
    -ca-key=./PKI/ca-key.pem \
    -config=./PKI/ca-config.json \
    -profile=kubernetes \
    ./PKI/kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager

# Generate Kube Proxy Cert
cfssl gencert \
    -ca=./PKI/ca.pem \
    -ca-key=./PKI/ca-key.pem \
    -config=./PKI/ca-config.json \
    -profile=kubernetes \
    ./PKI/kube-proxy-csr.json | cfssljson -bare kube-proxy

# Generate Kube Scheduler Cert
cfssl gencert \
    -ca=./PKI/ca.pem \
    -ca-key=./PKI/ca-key.pem \
    -config=./PKI/ca-config.json \
    -profile=kubernetes \
    ./PKI/kube-scheduler-csr.json | cfssljson -bare kube-scheduler

# Generate API Server Cert
kubernetes_hostnames=kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster,kubernetes.svc.cluster.local
cfssl gencert \
  -ca=./PKI/ca.pem \
  -ca-key=./PKI/ca-key.pem \
  -config=./PKI/ca-config.json \
  -hostname=10.32.0.1,10.100.0.10,10.100.0.11,10.100.0.12,${static_ip},127.0.0.1,${kubernetes_hostnames} \
  -profile=kubernetes \
  ./PKI/kubernetes-csr.json | cfssljson -bare kubernetes

# Generate Service Account Cert
cfssl gencert \
    -ca=./PKI/ca.pem \
    -ca-key=./PKI/ca-key.pem \
    -config=./PKI/ca-config.json \
    -profile=kubernetes \
    ./PKI/service-account-csr.json | cfssljson -bare service-account

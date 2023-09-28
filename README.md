# setup-nft-redirect

A helper image to set up tcp/udp port redirects. Useful within k8s with kube-router and [dsr](https://github.com/cloudnativelabs/kube-router/blob/master/docs/dsr.md) until it supports port mapping (https://github.com/cloudnativelabs/kube-router/blob/master/docs/dsr.md#things-to-lookout-for).

## Usage

Usually containers run without root privileges, thus they cannot bind to privileged ports. To keep this restriction and allow for privileged ports to be used as service ports, a port-mapping can be setup. The following deployment example shows this:

```
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: nginx
  name: nginx
spec:
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - image: nginxinc/nginx-unprivileged
        name: nginx-unprivileged
      initContainers:
      - image: ghcr.io/k-web-s/setup-nft-redirect
        name: setup-redirect
        args:
        - tcp:80:8080
        securityContext:
          capabilities:
            add:
            - NET_ADMIN
      securityContext:
        runAsNonRoot: true
```

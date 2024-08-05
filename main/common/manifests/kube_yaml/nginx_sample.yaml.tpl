apiVersion: v1
kind: Pod
metadata:
  name: ${app_name}
  namespace: ${app_namespace}
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
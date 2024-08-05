apiVersion: v1
kind: Service
metadata:
  annotations:
    service.beta.kubernetes.io/azure-load-balancer-resource-group: ${node_group_name}
    service.beta.kubernetes.io/azure-pip-name: ${pip_name}
    service.beta.kubernetes.io/azure-dns-label-name: "oschoony"
  name: azure-load-balancer
spec:
  type: LoadBalancer
  ports:
  - port: 80
  selector:
    app: azure-load-balancer
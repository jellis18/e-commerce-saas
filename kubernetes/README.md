# Kubernetes Deployment Setup

We aim to make the deployment process as automated as possible but some manual steps are
required the first time.

## Creating the EKS cluster

While this could be done with `terraform` (and I would like to do this eventually),
`eksctl` is just so much easier. We will do this through a configuration yaml file

```yaml
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: proshop
  region: us-east-2
  version: '1.19'
nodeGroups:
  - amiFamily: AmazonLinux2
    desiredCapacity: 10
    minSize: 5
    maxSize: 15
    instanceType: t2.micro
    name: linux-nodes
    iam:
      attachPolicyARNs:
        - arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy
        - arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy
        - arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly
        - arn:aws:iam::402008821676:policy/EC2AccessS3
    ssh:
      allow: true
```

The above, will create an EKS cluster with a worker group comprised of 10 `t2.micro`
instances (that can scale up to 15 nodes). We allow for ssh access and attach a custom
policy (`EC2AccessS3`) that will allows us to access the s3 bucket that is used for media
files (this resource was created by terraform in an earlier step). The other roles are the
defaults used by `eksctl`.

To create the cluster run:

```bash
eksctl create cluster -f kubernetes/cluster.yaml
```

and wait a while.

## Creating the NGINX ingress controller

For us to use ingress in our applicatin we must deploy an ingress controller. For this
case we are using the NGINX ingress controller and we simply follow the steps [here](https://kubernetes.github.io/ingress-nginx/deploy/#aws), namely

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/aws/deploy.yaml
```

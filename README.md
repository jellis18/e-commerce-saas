# E-commerce Site: From development to production

This repository is the outcome of a week-long code sprint to teach myself how to make a production website
using several different DevOps and deployment tools. 

The base e-commerce site here is from the great Udemy course [Django with React | An Ecommerce Website](https://www.udemy.com/course/django-with-react-an-ecommerce-website/). The goal here is not to make a "real" e-commerce site but instead to give a real-life example of deploying a system to production. 

## Technologies used in this project

Developing this project was a great learning experience and one day I hope to turn it into a more formal course/blog post/video or something. For now I'll give
an overview of the technoligies used and how they fit in to the overall production system.

### Base Site
The base e-commerce site here used [Django](https://www.djangoproject.com/) with the [Django REST framework](https://www.django-rest-framework.org/) and [PostgreSQL](https://www.postgresql.org/) for the backend and [React](https://reactjs.org/) using [Redux](https://react-redux.js.org/) for state management 
for the frontend. Following the course, I also use AWS s3 buckets along with [WhiteNoise](http://whitenoise.evans.io/en/stable/) to store and serve user-uploaded media files. Other than a few small changes the basic website and code is exactly the same as the Udemy course. I had never used Django or React so I just wanted 
to follow along. 

### Containerization and Local Depoloyment

Once the basic site was build the next step towards production was to containerize the application. To do this I used [Docker](https://www.docker.com/) to containerize the [backend](https://github.com/jellis18/e-commerce-saas/tree/master/docker/backend) 
and [frontend](https://github.com/jellis18/e-commerce-saas/tree/master/docker/frontend). For the frontend I created a "development" and a "production" container. The development container just runs `npm` as you would normally during development and allows for hot-reloads. For the production conatiner I used [NGINX](https://www.nginx.com/) as reverse-proxy to handle the communication between frontend and backend.

To handle the networking and connections to the Postgres database I used [Docker Compose](https://docs.docker.com/compose/) creating both a [dev](https://github.com/jellis18/e-commerce-saas/blob/master/docker-compose.yml) [production](https://github.com/jellis18/e-commerce-saas/blob/master/docker-compose-production.yml) deployment. 

Depending on the usecase, this could be the end. You could deploy with docker compose on EC2, Heroku, etc. But I wanted to go further...

### Infrasturcture as Code for resource deployment

Even the basic web application requires an s3 bucket to store the media files. Of course we can follow the web UI and just create an s3 bucket but I wanted to devopsify this thing.

I took another great Udemy course [Complete Terraform Course - Beginner to Advanced](https://www.udemy.com/course/complete-terraform-course-beginner-to-advanced/) on [terraform](https://www.terraform.io/) and I wanted to try it out. Let me tell you, you will feel like a freakin wizard after using terraform!

For this project I needed a few AWS resources. First, I needed the s3 bucket to host and serve the media files, but I also wanted to store my Docker images in [AWS ECR](https://aws.amazon.com/ecr/) and I also wanted to use [Github Actions](https://github.com/features/actions) to build and push the web app Docker images. So that is what I did:

* [s3 bucket for media files (+ a bit needed for Kubernetes...)](https://github.com/jellis18/e-commerce-saas/blob/master/terraform/s3.tf)
* [ECR resources for Docker images](https://github.com/jellis18/e-commerce-saas/blob/master/terraform/ecr.tf)
* [Github Actions user with minimum required permissions to push to ECR](https://github.com/jellis18/e-commerce-saas/blob/master/terraform/github_actions.tf)

A last note on terraform and AWS. If you want to learn about [IAM](https://aws.amazon.com/iam/) deploy some resources with terraform. Way more explicit than using the web UI.

### Kubernetes

Ok, I wanted to use terraform for setting up an configuring an [EKS](https://aws.amazon.com/eks/) but it was a bit daunting. Instead I used [eksctl](https://eksctl.io/) which is another IaC tool but a bit more high-level than doing it with terraform. I have written some (incomplete) instructions [here](https://github.com/jellis18/e-commerce-saas/blob/master/kubernetes/README.md) on how this is used to setup our EKS cluster. Just to note, I also had to [add a custom role in AWS](https://github.com/jellis18/e-commerce-saas/blob/master/terraform/s3.tf#L30) so the EC2 worker nodes can access the s3 bucket that stores the media files.

Getting things deployed with Kubernetes took a bit of trial and error. As an overview I used [Kustomize](https://kustomize.io/) to configure the deployment. For this app I didn't separate out dev and prod but it is still good practice. I also used the NGINX Ingress to manage the communication and entrypoint into the web application.



# gvm-containers

## Introduction
This is the Git repo of the tools to deploy Greenbone Vulnerability
Management with containers. It is based on the [Greenbone Source
Edition (GSE)](https://community.greenbone.net) open source project.

## Docker images

### for Greenbone Vulnerability Management 21.4
Based on [admirito's GVM PPA] (https://launchpad.net/~mrazavi/+archive/ubuntu/gvm)
The source docker images hosted on this repo. It contains the source for the following docker
images:
* [gvmd](https://hub.docker.com/r/admirito/gvmd): Greenbone Vulnerability Manager
* [gsad](https://hub.docker.com/r/admirito/gsad): Greenbone Security Assistant
* [gvm-postgres](https://hub.docker.com/r/admirito/gvm-postgres): PostgreSQL 12 Database with libgvm-pg-server
  extension to be used by gvmd

### for Greenbone Vulnerability Management 22.4

Based on the ubuntu Lunar (23.04) : https://launchpad.net/ubuntu/+source/openvas-scanner

The source docker images hosted on this repo. It contains the source for the following docker
* [openvas-scanner](https://hub.docker.com/r/konvergence/openvas-scanner): OpenVAS remote network security scanner



## Docker Compose
To setup the GVM system with =docker-compose=, first clone the repo and
issue =docker-compose up= commands to download and synchronize the data
feeds required by the GVM:

* synchronize data feeds
```
git clone https://github.com/konvergence/gvm-containers.git

cd gvm-containers

docker-compose -f nvt-sync.yml up
docker-compose -f cert-sync.yml up
docker-compose -f scap-sync.yml up
docker-compose -f gvmd-data-sync.yml up
```

Then, you can run GVM services with a simple =docker-compose up=
command. The initialization process can take a few minutes for the
first time:

* run GVM with docker-compose

```
# in the gvm-containers directory
docker-compose up -d
```

The Greenbone Security Assistant =gsad= port is exposed on the
host's port 8080. So you can access it from [[http://localhost:8080]].

## Helm Chart

A helm chart for deploying the docker images on kubernetes is also available. 


**WARNING: Breaking changes**
  * since  helm chart 1.5.0+, 
  * dependencies **gvmd-db** is renamed to **postresql**
  * dependencies **openvas-redis** is renamed to **redis**

**Usage**

* To install GVM on a kubernetes cluster, first create a namespace and then install the helm chart:

* install on the kubernetes cluster
```
kubectl create namespace gvm

read -s -p "DB_PASS:" DB_PASS

kubectl -n gvm create secret generic postgresql-secret --from-literal=postgresql-password=${DB_PASS}


helm install gvm \
    https://github.com/konvergence/gvm-containers/releases/download/chart-1.5.0/gvm-1.5.0.tgz \
    --namespace gvm --set gvmd-db.auth.existingSecret="postgresql-secret" --set gvmd-db.auth.secretKeys.userPasswordKey="postgresql-password"
```

By default a cron job with a =@daily= schedule will be created to
update the GVM feeds. You can also enable a helm post installation
hook to perform the feeds synchronization before the installation is
complete by adding ~--timeout 90m --set syncFeedsAfterInstall=true~
arguments to the =helm install= command. Of course, this will slow
down the installation process considerably, although you can view the
feeds sync post installation progress by =kubectl logs= command:

* install on the kubernetes cluster
```
NS=gvm

kubectl logs -n $NS -f $(kubectl get pod -n $NS -l job-name=gvm-feeds-sync -o custom-columns=:metadata.name --no-headers)
```

Please note that =feed.community.greenbone.net= servers will only
allow only one feed sync per time so you should avoid running multiple
feed sync jobs, otherwise the source ip will be temporarily
blocked. So if you are enabling =syncFeedsAfterInstall= you have to
make sure the cron job will not be scheduled during the post
installation process.

For more information and see other options please read the
[./chart/README.md](chart/README.md).

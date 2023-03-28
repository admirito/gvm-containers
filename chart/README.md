# Helm chart for Greenbone Vulnerability Management (GVM)
## Introduction
You can use the provided helm chart in this repository to deploy
Greenbone Source Edition (GSE) on your kubernetes cloud.

## Getting Helm
To use "helm" you have to first install it! For more information about
installing helm follow the instructions at [[https://github.com/helm/helm#install][helm installation notes]].

## Building chart from source
Use the following instructions to build the gvm helm chart from
source:

* build helm chart for gvm
```
git clone https://github.com/konvergence/gvm-containers.git

cd gvm-containers/chart

helm dependency build gvm
helm package gvm
```

This should leave you with a =gvm-*.tgz= file ready to be deployed in
the k8s.

## Installing GVM via helm chart
GVM uses several components and databases that should be deployed on
k8s. Therefore, to have better control on you installation it is
recommended to crate a separate namespace for it:

* create a namespace for GVM installation
```
kubectl create namespace gvm
```

Then you can install the chart with helm:

* install GVM helm chart
```
read -s -p "DB_PASS:" DB_PASS
kubectl -n gvm create secret generic postgresql-secret --from-literal=postgresql-password=${DB_PASS}



helm install gvm ./gvm-*.tgz --namespace gvm -set gvmd-db.auth.existingSecret="postgresql-secret" --set gvmd-db.auth.secretKeys.userPasswordKey="postgresql-password"
```

You can also provide =persistence= configuration, to make sure your
data persist in pods life cycle, correctly. Note that =persistence=
options are for =gvmd= and =openvas= data files, while
=gvmd-db.persistence= and =openvas-redis.master.persistence= are for
=postgres= and =redis= accordingly.

By default three =PVC= objects with =ReadWriteOnce= access modes will
be created and some of the volumes will be mounted on multiple pods.
So you have to make sure the volumes are available on all the cluster
nodes.

** Configuration
The following table lists some of the useful configurable parameters
of the GVM chart and their default values. For a complete list see
[values.yaml](./gvm/values.yaml) file.

| Parameter                             | Description                                               | Default |
|---------------------------------------+-----------------------------------------------------------+---------|
| image.gvmd.tag                        | the docker tag for gvmd image                             | 21      |
| image.gsad.tag                        | the docker tag for gsad image                             | 21      |
| image.openvas.tag                     | the docker tag for openvas image                          | 21      |
| gvmd-db.image.tag                     | the docker tag for gvm-postgres image                     | 21      |
| secrets.gvmdUsername                  | the username for gvmd                                     | admin   |
| secrets.gvmdPassword                  | the password for gvmd                                     | admin   |
| gvmd-db.postgresqlPassword            | the password for "gvmduser" in "gvmd" postgresql database | ""      |
| syncFeedsAfterInstall                 | sync all the GVM feeds with post-install hooks            | false   |
| syncFeedsCronJob.enabled              | create a cron job to sync GVM feeds                       | true    |
| syncFeedsCronJob.schedule             | the feed sync cron job schedule                           | @daily  |
| persistence.size                      | storage request size for the data (nvt/scap/cert) pvc     | 5Gi     |
| gvmd-db.persistence.size              | storage request size for the postgresql pvc               | 8Gi     |
| openvas-redis.master.persistence.size | storage request size for the redis pvc                    | 8Gi     |

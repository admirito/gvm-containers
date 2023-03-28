* Helm chart for Greenbone Vulnerability Management (GVM)
** Introduction
You can use the provided helm chart in this repository to deploy
Greenbone Source Edition (GSE) on your kubernetes cloud.

** Getting Helm
To use "helm" you have to first install it! For more information about
installing helm follow the instructions at [[https://github.com/helm/helm#install][helm installation notes]].

** Building chart from source
Use the following instructions to build the gvm helm chart from
source:

#+NAME: build helm chart for gvm
#+BEGIN_SRC shell
git clone https://github.com/admirito/gvm-containers.git

cd gvm-containers/chart

helm dependency build gvm
helm package gvm
#+END_SRC

This should leave you with a =gvm-*.tgz= file ready to be deployed in
the k8s.

** Installing GVM via helm chart
GVM uses several components and databases that should be deployed on
k8s. Therefore, to have better control on you installation it is
recommended to crate a separate namespace for it:

#+NAME: create a namespace for GVM installation
#+BEGIN_SRC shell
kubectl create namespace gvm
#+END_SRC

Then you can install the chart with helm:

#+NAME: install GVM helm chart
#+BEGIN_SRC shell
helm install gvm ./gvm-*.tgz --namespace gvm --set gvmd-db.postgresqlPassword="mypassword"
#+END_SRC

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
[[./gvm/values.yaml][values.yaml]] file.

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

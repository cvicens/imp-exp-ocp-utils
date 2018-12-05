# Introduction

Export images referred to in a image-stream definition (probably pointing to a public image registry such as Docker Hub or Red Hat Registry)

# 1.- Export image-stream definition from your 'source' Openshift instance

Use next example to export the image-stream used for JDK S2I

```
$ oc get is -n openshift | grep jdk
redhat-openjdk18-openshift                     docker-registry.default.svc:5000/openshift/redhat-openjdk18-openshift                     1.4,1.0,1.1 + 2 more...      2 days ago

$ oc get is redhat-openjdk18-openshift -n openshift -o yaml > redhat-openjdk-image-stream.yaml
```

# Pull remote images from 'source' Openshift instance

```
./01-pull-remote-images.sh redhat-openjdk-image-stream.yaml
```

# Copy the zipped files from your local directory to the destination location

Use whichever means to copy the *.tar.gz files (images) from this local directory to the destination localtion where `oc` command is installed and set up to connect to the destination Openshift installation.

Note: if you can reach the destination cluster from your local machine, there's no need to copy files anywhere

# Once in the destination machine

Make sure pre-requisites (yq and jq binaries installed and in PATH) are met before going on.

Login as an admin user.

```
oc login https://master.example.com -u admin -p password

```


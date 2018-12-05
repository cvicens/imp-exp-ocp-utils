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

Use whichever means to copy the image-stream () file along with the *.tar.gz files (images) from this local directory to the destination localtion where `oc` command is installed and set up to connect to the destination Openshift installation.

Note: if you can reach the destination cluster from your local machine, there's no need to copy files anywhere

# Push images to the local Openshift registry

Once in the destination machine, make sure pre-requisites (yq and jq binaries installed and in PATH) are met before going on.

Login as an admin user, then run our `02-push-remote-images.sh` providing the name of the image-stream file and the name of the destination namespace where we want to have our image-stream.

```
oc login https://master.example.com -u admin -p password

./02-push-remote-images.sh redhat-openjdk-image-stream.yaml lab-infra

```

# Create a sample app with our new s2i image stream

The sample script `./03-deploy-sample-app.sh` will create a new app, given the following parameters.

- FROM_IMAGE_STREAM_FILE: image-stream file we used to export images
- LOCAL_IMAGE_STREAM_NAMESPACE: local namespace where we have imported the original images
- NAMESPACE: namespace where we want to deploy our app
- APP_NAME: name we want for our app
- GIT_URL: git repository url
- [GIT_CONTEXT_DIR]: optionally, context directory where the code is

```
./03-deploy-sample-app.sh redhat-openjdk-image-stream.yaml lab-infra tests https://github.com/cvicens/wine pairing
```

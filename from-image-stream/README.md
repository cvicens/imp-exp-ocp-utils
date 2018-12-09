# Introduction

Export images referred to in a image-stream definition (probably pointing to a public image registry such as Docker Hub or Red Hat Registry)

# 1.- Export image-stream definition from your 'source' Openshift instance

Use next example to export the image-stream used for JDK S2I

```
$ oc get is -n openshift | grep jdk
redhat-openjdk18-openshift                     docker-registry.default.svc:5000/openshift/redhat-openjdk18-openshift                     1.4,1.0,1.1 + 2 more...      2 days ago

$ oc get is redhat-openjdk18-openshift -n openshift -o json > redhat-openjdk-image-stream.json
```

# Pull remote images from 'source' Openshift instance

```
./01-pull-remote-images.sh redhat-openjdk-image-stream.json
```

# Copy the zipped files from your local directory to the destination location

Use whichever means to copy the image-stream () file along with the *.tar.gz files (images) from this local directory to the destination localtion where `oc` command is installed and set up to connect to the destination Openshift installation.

Note: if you can reach the destination cluster from your local machine, there's no need to copy files anywhere

# Prepare to connect to Docker using a not trusted certificate in RHEL

```
$ openssl s_client -connect master.serverless-e442.openshiftworkshop.com:443 -showcerts 2>&1 < /dev/null
CONNECTED(00000003)
depth=1 CN = openshift-signer@1544282579
verify error:num=19:self signed certificate in certificate chain
---
Certificate chain
 0 s:/CN=172.30.0.1
   i:/CN=openshift-signer@1544282579
-----BEGIN CERTIFICATE-----
MIIELzCCAxegAwIBAgIBAzANBgkqhkiG9w0BAQsFADAmMSQwIgYDVQQDDBtvcGVu
c2hpZnQtc2lnbmVyQDE1NDQyODI1NzkwHhcNMTgxMjA4MTUyMzAwWhcNMjAxMjA3
MTUyMzAxWjAVMRMwEQYDVQQDEwoxNzIuMzAuMC4xMIIBIjANBgkqhkiG9w0BAQEF
AAOCAQ8AMIIBCgKCAQEAylgcaByYC0BepflNCzQjYpLqeczystJQwB1dTprBiCv4
AZHmyLaSer0QNkM9PTK9/9a/U81k79ZxF6l0xv0P7tLgyuH5fyvz58dHDqsYiZYB
r1IZWpZEoUcmePnpixduy7I0dJxhwFK6z61JAuf8mVzTNaKRsMkyNNZUiYy3eXBp
/w7aSlWjbpKbVlX68aBZoeYHvoxv+ImyVJwcix4PRyFw7Nn27rJNEc/ezwBllYKJ
lCOR6rGMGbCjZafBF00mKBUXA3UyqQfQ4x7qQOn1nfKvtTcroPnohTD5W5DVt1we
JGTO+1QTG4umTzKyPYpvzRbyxhBMIkKjkf6JhBLWJQIDAQABo4IBdzCCAXMwDgYD
VR0PAQH/BAQDAgWgMBMGA1UdJQQMMAoGCCsGAQUFBwMBMAwGA1UdEwEB/wQCMAAw
ggE8BgNVHREEggEzMIIBL4IKa3ViZXJuZXRlc4ISa3ViZXJuZXRlcy5kZWZhdWx0
ghZrdWJlcm5ldGVzLmRlZmF1bHQuc3ZjgiRrdWJlcm5ldGVzLmRlZmF1bHQuc3Zj
LmNsdXN0ZXIubG9jYWyCLG1hc3Rlci5zZXJ2ZXJsZXNzLWU0NDIub3BlbnNoaWZ0
d29ya3Nob3AuY29tgiBtYXN0ZXIxLnNlcnZlcmxlc3MtZTQ0Mi5pbnRlcm5hbIIJ
b3BlbnNoaWZ0ghFvcGVuc2hpZnQuZGVmYXVsdIIVb3BlbnNoaWZ0LmRlZmF1bHQu
c3ZjgiNvcGVuc2hpZnQuZGVmYXVsdC5zdmMuY2x1c3Rlci5sb2NhbIIKMTcyLjMw
LjAuMYINMTkyLjE5OS4wLjEyMYcErB4AAYcEwMcAeTANBgkqhkiG9w0BAQsFAAOC
AQEANDZPW0IZNRRsUaMURqt3KtHLQ0Q8cRCGAUefziPONls/fFx0GHDscpS/kAIf
bko2pVtWdeejXDoTC7vWF65358xdDup18zQqqmBNgtrIxYN5mjzxYpxccEovajxj
1ru07uNZCefuSZjTnsRcLRFMDlpCErZvXHXsscIJAp7XscTKiHQ1xxmgnN1CAN8i
1VcY+dzRTsNN0hYXrfPeY3qjhcmLXvUraTjM/jH2X0DiIn4FFHa4h7gxh9wMSuby
Slakhatbr+MBGKhBH8oWAcENX4uwf+HyBFo4YCP50sBH4WERLB8x/qVRikn2YXO+
aPBOzyXBpFkpWeubt+YP1sAACg==
-----END CERTIFICATE-----
 1 s:/CN=openshift-signer@1544282579
   i:/CN=openshift-signer@1544282579
-----BEGIN CERTIFICATE-----
MIIC6jCCAdKgAwIBAgIBATANBgkqhkiG9w0BAQsFADAmMSQwIgYDVQQDDBtvcGVu
c2hpZnQtc2lnbmVyQDE1NDQyODI1NzkwHhcNMTgxMjA4MTUyMjU5WhcNMjMxMjA3
MTUyMzAwWjAmMSQwIgYDVQQDDBtvcGVuc2hpZnQtc2lnbmVyQDE1NDQyODI1Nzkw
ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDLmzYQ64pIphtcZgjGL7hr
SK89X44fk+5UCxmvW3BoRwxtoyUQEhuXLInCkVr7ccWwb7HADKVT73i99icYRXh1
Xbo21z25SK+lSUZ5UZ20jqcFkgRjhkY1YDiAPeXlI0ikomarmDAVYNPXqcq3kY2N
Mcl6wZdRoKPKv16APbJcoDULKJpWcTpGLEDZZHqeNwr3LGJJBvBx4ED/L/Tuqybv
xggxLpJsLPBkIK/YVOYO17IajoamcEzI3WWFGTUYgLC9adlr3GvE+STklXwedB4g
fMK2v0WJOH92ZLHWl1CkfJWdLzQqyAHjB/Q6/PeqZJBGOQqp7a2Prj/d37WQlQgz
AgMBAAGjIzAhMA4GA1UdDwEB/wQEAwICpDAPBgNVHRMBAf8EBTADAQH/MA0GCSqG
SIb3DQEBCwUAA4IBAQDHqldeooI4bJOCxIpSN1pDOBMOPdtVRsZeuutAWrrZGbZZ
JY0cCZ4Si3NguAz57vo0RNnlnjnW15aovm35MDJ8CjYdrDPNbdvj+Guakex8wVRO
6UZI0UIMjvEbbqKkWh9QBdGS7t9YHCSaxMDjZ2Fyo/GhZjDLXM5wJsqJSBWXsdzp
2M1jdD1kcDqSWAIwDRT3ggbtNfwRaJvizlEC/2lO9hqOjNvNsuXQKKR+DG5xZVjo
P1evB5P8sNHFlrdjbkMChWgRprPczdjcaBzz/vcP7Ye7mFtnkgDSmf9uXJP0sxJi
6Zh+nlUmZZiqAOicHCPhw2Xpy1k3y2BQjYpsV6k6
-----END CERTIFICATE-----
---
Server certificate
subject=/CN=172.30.0.1
issuer=/CN=openshift-signer@1544282579
---
Acceptable client certificate CA names
/CN=openshift-signer@1544282579
/CN=openshift-signer@1544282578
Client Certificate Types: RSA sign, ECDSA sign
Requested Signature Algorithms: RSA+SHA256:ECDSA+SHA256:RSA+SHA384:ECDSA+SHA384:RSA+SHA512:ECDSA+SHA512:RSA+SHA1:ECDSA+SHA1
Shared Requested Signature Algorithms: RSA+SHA256:ECDSA+SHA256:RSA+SHA384:ECDSA+SHA384:RSA+SHA512:ECDSA+SHA512:RSA+SHA1:ECDSA+SHA1
Peer signing digest: SHA512
Server Temp Key: ECDH, P-256, 256 bits
---
SSL handshake has read 2550 bytes and written 427 bytes
---
New, TLSv1/SSLv3, Cipher is ECDHE-RSA-AES128-GCM-SHA256
Server public key is 2048 bit
Secure Renegotiation IS supported
Compression: NONE
Expansion: NONE
No ALPN negotiated
SSL-Session:
    Protocol  : TLSv1.2
    Cipher    : ECDHE-RSA-AES128-GCM-SHA256
    Session-ID: 06B716F047357BF37C7A9691C67B7BFF731F5B6B53811E128018D268FA8D1183
    Session-ID-ctx: 
    Master-Key: D8FB7B2C83B9886E5A1D678C23C17BB7012ECE19741126B4D9F80FCC7CB75CC82361460B120D2D87CC024ADB8E52E557
    Key-Arg   : None
    Krb5 Principal: None
    PSK identity: None
    PSK identity hint: None
    TLS session ticket:
    0000 - 69 5c 8e 90 18 98 91 6f-e6 dd 61 ba 5b 8a d8 4e   i\.....o..a.[..N
    0010 - f1 43 a2 3f 92 dd a4 5a-26 56 57 0f db 19 3e 88   .C.?...Z&VW...>.
    0020 - d3 08 1c 5e 77 b0 ba 02-8b ac ea 5f 0f 59 7e 1a   ...^w......_.Y~.
    0030 - c0 16 d3 5c 7f b2 7b df-24 e7 f8 36 6b 3b 29 28   ...\..{.$..6k;)(
    0040 - 7f 53 a9 1d 87 d2 e4 30-47 b9 cc 0b 2f 8c 52 9c   .S.....0G.../.R.
    0050 - d3 bd 9e fa 4b c2 55 f5-f9 dd bc 4f 6b 42 9a 05   ....K.U....OkB..
    0060 - 5f 46 b1 f0 33 db 98 b1-9b 68 77 eb bc 43 4e 7f   _F..3....hw..CN.
    0070 - 95 04 ec 23 73 5a 5a 16-                          ...#sZZ.

    Start Time: 1544377172
    Timeout   : 300 (sec)
    Verify return code: 19 (self signed certificate in certificate chain)
---
DONE
```

Copy and paste the highest order certificate, in this case '1' to a file, let's say caroot.crt

```
-----BEGIN CERTIFICATE-----
MIIC6jCCAdKgAwIBAgIBATANBgkqhkiG9w0BAQsFADAmMSQwIgYDVQQDDBtvcGVu
c2hpZnQtc2lnbmVyQDE1NDQyODI1NzkwHhcNMTgxMjA4MTUyMjU5WhcNMjMxMjA3
MTUyMzAwWjAmMSQwIgYDVQQDDBtvcGVuc2hpZnQtc2lnbmVyQDE1NDQyODI1Nzkw
ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDLmzYQ64pIphtcZgjGL7hr
SK89X44fk+5UCxmvW3BoRwxtoyUQEhuXLInCkVr7ccWwb7HADKVT73i99icYRXh1
Xbo21z25SK+lSUZ5UZ20jqcFkgRjhkY1YDiAPeXlI0ikomarmDAVYNPXqcq3kY2N
Mcl6wZdRoKPKv16APbJcoDULKJpWcTpGLEDZZHqeNwr3LGJJBvBx4ED/L/Tuqybv
xggxLpJsLPBkIK/YVOYO17IajoamcEzI3WWFGTUYgLC9adlr3GvE+STklXwedB4g
fMK2v0WJOH92ZLHWl1CkfJWdLzQqyAHjB/Q6/PeqZJBGOQqp7a2Prj/d37WQlQgz
AgMBAAGjIzAhMA4GA1UdDwEB/wQEAwICpDAPBgNVHRMBAf8EBTADAQH/MA0GCSqG
SIb3DQEBCwUAA4IBAQDHqldeooI4bJOCxIpSN1pDOBMOPdtVRsZeuutAWrrZGbZZ
JY0cCZ4Si3NguAz57vo0RNnlnjnW15aovm35MDJ8CjYdrDPNbdvj+Guakex8wVRO
6UZI0UIMjvEbbqKkWh9QBdGS7t9YHCSaxMDjZ2Fyo/GhZjDLXM5wJsqJSBWXsdzp
2M1jdD1kcDqSWAIwDRT3ggbtNfwRaJvizlEC/2lO9hqOjNvNsuXQKKR+DG5xZVjo
P1evB5P8sNHFlrdjbkMChWgRprPczdjcaBzz/vcP7Ye7mFtnkgDSmf9uXJP0sxJi
6Zh+nlUmZZiqAOicHCPhw2Xpy1k3y2BQjYpsV6k6
-----END CERTIFICATE-----

```

As root, or using sudo.

```
$ update-ca-trust enable
$ cp caroot.crt /etc/pki/ca-trust/source/anchors/
$ update-ca-trust extract
```


Verify if caroot cert has been installed properly.

```
$ openssl verify caroot.crt
caroot.crt: OK
```

# Push images to the local Openshift registry

Once in the destination machine, make sure pre-requisites (yq and jq binaries installed and in PATH) are met before going on.

Login as an admin user, then run our `02-push-remote-images.sh` providing the name of the image-stream file and the name of the destination namespace where we want to have our image-stream (if the namespace is not `openshift` then you have to give permissions to pull images from that namespace).

```
oc login https://master.example.com -u admin -p password

./02-push-remote-images.sh redhat-openjdk-image-stream.json lab-infra

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
./03-deploy-sample-app.sh redhat-openjdk-image-stream.json lab-infra my-tests my-app https://github.com/cvicens/wine pairing
```

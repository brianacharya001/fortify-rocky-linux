# Building the Fortify Server with UBI 8
This readme will identify how to build the Fority Server using the Universal Build Image 8

## Login with RedHat Developer Account
Make sure before building the UBI 8 that you are logged in with a Redhat Developer Account. 

## Building Locally
To build the image locally run the following:
```
docker build . -f build/build-fortify-rocky -t fortify-rocky
```

# Run the Image Locally by running
```
docker run -d -p 443:2424 --name fortify fortify-rocky
```

## Get the Token by running
cat /root/.fortify/ssc/init.token
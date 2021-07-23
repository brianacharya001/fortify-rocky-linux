# Building the Fortify Server with Rocky Linux
This readme will identify how to build the Fority Server using the Universal Build Image 8

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
server-manager-kernel
========
Docker file for building Wheezy kernel for server-manager

Steps:

    # build image
    docker build -t kernel .

    # or build directly via build.sh script
    ./build.sh

    # upload to s3 apt repo
    # (you can install deb-s3 via gem install deb-s3)
    deb-s3 upload --endpoint=s3.eu-central-1.amazonaws.com --bucket $BUCKET_NAME -c wheezy -m main linux-*.deb

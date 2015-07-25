# Shruti deployment

This repository contains deploymnet scripts for Shruti project

Entire system can be installed on either platform, GNU/Linux, Mac OS X and Microsoft Windows.

There are multiple ways to deploy the system. Choose whichever suits better.

All the methods are described in this document in brief

    - using docker
        - choose this if you are deploying on aws like, or if you don't mind downloading huge image files
        - tested on Ubuntu only
    - without using docker at all, download and deploy binaries
        - you have to install postgres, Java runtime and flyway on your own
        - binaries are available for GNU/Linux, Mac OS X and Microsoft Windows
    - build and run
        - go to each directory and run.sh
        - dev setup

Once the deployment is done, you may want to configure nginx, sample config file can be found in `nginx` directory

# Environment Variables

In either method of deployment, you will have to configure few environment variables in between.

Essential ones are listed below.

[Pusher](http://pusher.com) support is optional, it will run in polling mode if pusher key is not present

- If you are using docker, edit docker-compose.yml
- If you are not using docker at all, edit respective project's run.sh scripts

```
    - shruti
        - SHRUTI_PUSHER_APPID
        - SHRUTI_PUSHER_KEY
        - SHRUTI_PUSHER_SECRET
    - ivona-service
        - IVONA_ACCESSKEY
        - IVONA_SECRETKEY
    - shruti-client
        - SHRUTI_API_URL                    # point to shruti server
        - SHRUTI_IVONA_URL                  # point to ivona-service
        - SHRUTI_CLIENT_REFRESH_INTERVAL
        - SHRUTI_CLIENT_ID                  # for now this can be anything
        - SHRUTI_PUSHER_API_KEY
    - provider containers
        - SHRUTI_SERVER
    - provider-reddit
        - REDDIT_FEED_URL
```

# Docker pain points

You normally don't have to worry about these, should help debugging if it doesn't work


- postgres
    - data is not to be saved inside container. [to make sure its persistent]
    - `data` directory is created and mounted in postgres container
- flyway
    - sql migrations are kept outside the container in `sql` directory
    - directory is mounted in the container
- ivona-service and providers
    - these containers are extremely lightweight and don't have openssl support
    - host machine's certificates are used as a workaround
    - `/etc/ssl/certs` works for Ubuntu 14.04


# Using docker

```
    $ git clone https://github.com/Omie/shruti-deployment.git

    $ cd shruti-deployment

    $ vim docker-compose.yml  # set the variables

    $ ./install_docker_compose.sh

    $ sudo gpasswd -a ${user-name-here} docker

    $ ./deploy.sh
```

# Without docker

Download the binary release for your platform

- [GNU/Linux](http://foo.com/releases/latest/shruti_linux.tar)
- [Mac OS X](http://foo.com/releases/latest/shruti_osx.zip)
- [Microsoft Windows](http://foo.com/releases/latest/shruti_win.zip)

Extract the archive and follow the instructions in README.txt


# Build and run

```
    $ go get github.com/omie/shruti
    $ go get github.com/omie/shruti-client
    $ go get github.com/omie/ivona-service
    $ go get github.com/omie/shruti-providers
    $ cd $GOPATH
    $ # cd to each directory {shruti, shruti-client, ivona-service, shruti-providers...}
    $ # MAKE SURE TO EDIT run.sh to configure environment variables, API keys mostly
    $ ./run.sh # in each directories
```


License
-------

MIT License


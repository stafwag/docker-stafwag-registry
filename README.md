# docker-stafwag-registry

```Dockerfile``` to run docker-registry inside a docker container.
The ```registry```  daemon will run as the librarian user. The uid/gid is mapped
to 50000. The image is based on [Debian](https://www.debian.org/).

## Installation

### clone the git repo

```
$ git clone https://github.com/stafwag/docker-stafwag-registry.git
$ cd docker-stafwag-registry
```

### deb package or build from source

2 docker files are included:

* ```Dockerfile```:

  The default dockerfile will use the debian ```docker-registry``` package.

* ```Dockerfile_from_src```:

  Will compile the docker register from source.

  [https://github.com/distribution/distribution](https://github.com/distribution/distribution)

  You can set the git release version in the ```Dockerfile``` with

  ```ENV DOCKER_DISTRIBUTION_VERSION="v2.7.1"```


To compile the docker registry from source, you can use the ```-f Dockerfile_from_src``` argument.

```
$ docker build -f Dockerfile_from_src -t stafwag/registry .
```

### Update the configuration

```
$ vi etc/docker/registry/config.yml
```

The htpasswd authentication is enabled in the configuration.
You can mount the ```passwd``` file as a volume.

### Build the image

The command below builds the image image with the default ```BASE_IMAGE``` ```debian:bullseye```.

```
$ docker build -t stafwag/registry . 
```

To use a different ```BASE_IMAGE```, you can use the ```--build-arg BASE_IMAGE=your_base_image```.

```
$ docker build --build-arg BASE_IMAGE=stafwag/debian:bullseye -t stafwag/registry .
```

### Volume and passwd file
#### Create a directory for the docker registry.

```
$ sudo mkdir -p /home/volumes/docker/registry
$ sudo chown 50000:50000 /home/volumes/docker/registry
```

#### Create a htpasswd file

Create htpasswd file.

```-B``` set the hash to brcypt. ```-c``` creates a new file. 

```
$ htpasswd -B -c passwd ikke
New password: 
Re-type new password: 
Adding password for user ikke
```

Update the permissions.

```
$ sudo chown root:50000 passwd
$ sudo chmod 0640 passwd
$ ls -l passwd
-rw-r----- 1 root 50000 66 Jun  1 09:39 passwd
$ 
```

## Run

Run the docker command:

```
docker run -d --rm --name myregistry -p 5000:5000 -v /path/to/passwd:/etc/docker/registry/passwd -v /home/volumes/docker/registry:/var/lib/docker-registry stafwag/registry:latest
```

***Have fun***

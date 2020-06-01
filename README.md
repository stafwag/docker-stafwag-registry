# docker-stafwag-registery

```Dockerfile``` to run docker-registry inside a docker container.
The ```registry```  daemon will run as the librarian user. The uid/gid is mapped
50000.

## Installation

### clone the git repo

```
$ git clone https://github.com/stafwag/docker-stafwag-registry.git
$ cd docker-stafwag-registry
```

### Update the configuration


```
$ vi etc/docker/registry/config.yml
```

The htpasswd authentication is enabled in the configuration
You can mount the ```passwd``` file as a volume.

### Build the image

```
$ docker build -t stafwag/registry . 
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
docker run -d --rm --name myregistry -p 5000:5000 -v /path/to/passwd:/etc/docker/registry/passwd -v /home/volumes/docker/registry:/var/lib/registry stafwag/registry:latest
```

***Have fun***

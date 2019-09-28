Plate Solver
============

An [astrometry.net](astrometry.net) plate-solving service wrapped up in a Docker
image.

# Using `plate-solver`

## Get

### Get Docker
You will need to have [Docker](https://www.docker.com) up and running on your system.
The [official docs](https://www.docker.com/get-started) provide some ways to do this
but a simpel way is:

```bash
$ curl -fsSL https://get.docker.com -o get-docker.sh
$ sh get-docker.sh
```

> Note: you will probably need to restart or logout of current session before this
works properly. The above script will tell you what to do.

### Get `plate-solver` Image

Once you have the `docker` command on your system you will need to pull the `plate-solver`
image from the Google Cloud Registry servers:

```bash
$ docker pull gcr.io/panoptes-survey/plate-solver
```

## Setup

The `plate-solver` image contains a bash script that will properly run the astrometry.net
`solve-field` command.  The script will also check a set location for
[index files](http://astrometry.net/doc/readme.html#getting-index-files) and prompt
for download if they are not found. If you have existing index files you can specify
them the first time and a link will be created so you are not asked again.

### Create container

To get the script on your host system, first create a container from the image:

```bash
$ docker create --name plate-solver gcr.io/panoptes-survey/plate-solver
```

You can verify the container was created by listing the running containers:

```bash
$ docker ps -a
```

You should see something like:

```
➜ docker ps -a
CONTAINER ID        IMAGE                                 COMMAND             CREATED             STATUS              PORTS               NAMES
00034c0c60b6        gcr.io/panoptes-survey/plate-solver   "solve-field"       3 seconds ago       Created                                 plate-solver
```

### Copy `solve-field` script

Now we want to copy the `solve-field` script (this is our custom script) to your system and put it
somewhere so that you can use it.  The easiest way to do this is to create a `bin` directory in your
home directory:

```bash
# Go home
$ cd

# Create bin dir
$ mkdir -p ~/bin

# Copy all the binary files to host system.
$ docker run --rm -it \
    -v "$HOME/bin":/mnt \
    -u $(id -u):$(id -g) \
    gcr.io/panoptes-survey/plate-solver /bin/bash -c "cp -rv bin/* /mnt/"
```

### Setup `$PATH`

You will need to make sure your `$PATH` variable can find this directory:

> Note: Make sure to use single quotes in the following command.

```bash
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
```

You can then log in and out of your session or type:

```bash
source ~/.bashrc
```

## Use

In a terminal you can now type `solve-field` with all the normal options. If the
script cannot find any index files in an expected location it should prompt you
for locations of existing files or will ask to download the wide-field files.

```bash
$ solve-field starry_night.fits
```

# Building `plate-solver`

> Note: this is for developers working on the Docker image itself. If you just need
to use the plate-solver you can ignore this section.

## Building `plate-solver` image

There is a convenience script the will build the system on the `panoptes-survey` project
in Google Cloud Platform:

```bash
$ docker/build-image.sh
```
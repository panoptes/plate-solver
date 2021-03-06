Plate Solver
============

An [astrometry.net](http://astrometry.net/) plate-solving service wrapped up in a Docker image.

## Using `plate-solver`

> Warning: The below assumes that you are running a linux variant and have a user with an id of `1000`, which should be the case if you are the primary user on your system.
>
> You can check your user and group id with `id -u` and `id -g`.

### Get Docker

You will need to have [Docker](https://www.docker.com) up and running on your system.
The [official docs](https://www.docker.com/get-started) provide some ways to do this, but a simple
way is:

```bash
$ curl -fsSL https://get.docker.com -o get-docker.sh
$ sh get-docker.sh
```

> Note: you will probably need to restart or logout of current session before this works properly. The above script will tell you what to do.

### Get `plate-solver` Image

Once you have the `docker` command on your system you will need to pull the `plate-solver`
image from the Google Cloud Registry servers:

```bash
$ docker pull gcr.io/panoptes-exp/plate-solver
```

### Setup

To use the `solve-field` and other scripts you must first copy them to your host system. The easiest
way to do this is to create a `bin` directory in your home directory:

```bash
# Go home
$ cd

# Create bin dir
$ mkdir -p ~/bin

# Copy all the binary files to host system.
$ docker run --rm -it \
    -v "$HOME/bin":/tmp \
    gcr.io/panoptes-exp/plate-solver /bin/bash -c "cp -rv /app/* /tmp/"
```

### Setup `$PATH`

You will need to make sure your `$PATH` variable can find your `bin` directory:

> Note: Make sure to use single quotes in the following command.

```bash
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
```

You can then log in and out of your session or type:

```bash
source ~/.bashrc
```

### Use

In a terminal you can now type `solve-field` with all the normal options. If the script cannot find
any [index files](http://astrometry.net/doc/readme.html#getting-index-files)
in an expected location it should prompt you for locations of existing files or will ask to download
the wide-field files.

```bash
$ solve-field starry_night.fits
```

### Index files

The Dockerfile by default contains the Tycho2 4200 series index files. If you need additional index
files, download to a local folder and then see instructions in
`bin/run-astrometry-cmd`.

## Building `plate-solver`

> Note: this is for developers working on the Docker image itself. If you just need to use the plate-solver you can ignore this section.

### Building `plate-solver` locally

You can build with the standard docker commands. e.g.:

```bash
$ docker build --tag my-very-own-plate-solver .
```

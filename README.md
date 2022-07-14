Plate Solver
============

An [astrometry.net](http://astrometry.net/) plate-solving service wrapped up in a Docker image. 

This service will watch a directory for incoming files and plate-solve them.

Canon `CR2` files will be converted to `FITS` before solving.

## Using `plate-solver`

### Get Docker

You will need to have [Docker](https://www.docker.com) up and running on your system.
The [official docs](https://www.docker.com/get-started) provide some ways to do this, but a simple way is:

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
```

> Note: you will probably need to restart or logout of current session before this works properly. The above script will
> tell you what to do.

### Get `plate-solver`

Once you have the `docker` command on your system you will need to pull the
`panoptes-plate-solver` image from the Google Cloud Registry servers:

```bash
docker pull gcr.io/panoptes-exp/panoptes-plate-solver
```

### Use `plate-solver`

This service will perform the following:

* Attempt to extract a thumbnail from any `.cr2` files.
* Convert any `.cr2` files to `.fits` files.
* Plate-solve any `.fits` files.

#### Directories

The docker container has an `/incoming` and `/outgoing` directory that should be mapped
to the host directories you want to watch. These directories should exist before you
run the container.

> Note: you should not set the incoming directory to be the same as the outgoing directory.

#### Solve options

The default plate-solve options are:

```bash
SOLVE_OPTS="--guess-scale --no-verify --downsample 4 --temp-axy --no-plots"
```

which can be changed when running the container. See [example](#example) below.

The [`watchdog`](https://pypi.org/project/watchdog/) library provides the underlying event and handler class support.

### Example

```bash
# Map image directories to /incoming and /outgoing and set custom plate-solve options.
docker run --rm -it \
  -v "$PWD/images/:/incoming" \
  -v "$PWD/solved/:/outgoing" \
  -e SOLVE_OPTS="--guess-scale --no-verify --downsample 2 --no-plots" \
  gcr.io/panoptes-exp/panoptes-plate-solver
```

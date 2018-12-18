## Simple Docker example

First [install Docker](https://docs.docker.com/install/), and [add Docker to the proper group](https://docs.docker.com/install/linux/linux-postinstall/).

Build the Docker image:

```bash
docker build -t testinstall .
```

Then use the image to generate a running container. Use the `-a` flag to attach to the container's standard out.

```bash
docker run -a STDOUT testinstall
```


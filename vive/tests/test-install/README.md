## First working Docker example


First install Docker, and add Docker to the proper group.

cd into the `test-install` directory.

Build the Docker image:

```bash
docker build -t testinstall .
```

Then use the image to generate a running container. Use the `-a` flag to attach to the container's standard out.

```bash
docker run -a STDOUT testinstall
```


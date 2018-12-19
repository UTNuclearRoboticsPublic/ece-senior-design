# Use Ubuntu 16.04 as a base image
FROM ubuntu:16.04

# Run these commands during image construction
RUN apt-get update && apt-get install -y git

RUN git clone https://github.com/UTNuclearRoboticsPublic/ece-senior-design

WORKDIR ece-senior-design/vive/tests/test-install

# Run this when container is launched
CMD ["bash", "hello_world.sh"]

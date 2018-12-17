# Use Ubuntu 16.04 as a base image
FROM ubuntu:16.04

# COPY . /app

# WORKDIR /app

RUN apt-get update && apt-get install -y git

RUN git clone https://github.com/UTNuclearRoboticsPublic/ece-senior-design

# COPY . ece-senior-design/vive/tests/test-install

WORKDIR ece-senior-design/vive/tests/test-install

CMD ["bash", "test.sh"]

# Use Ubuntu 16.04 as a base image
FROM ubuntu:16.04

ARG branch_name

RUN apt-get update && apt-get install -y git sudo

RUN git clone -b ${branch_name} --single-branch https://github.com/UTNuclearRoboticsPublic/ece-senior-design

WORKDIR ece-senior-design/vive/install

CMD ["bash", "install.sh", "-c", "catkin", "-l", "log.txt"]

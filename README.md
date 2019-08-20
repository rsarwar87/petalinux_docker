# Introduction
Repo contains two different docker image for running from FPGA dev server hosting multiple users.

Both images uses --volume to sync workspace and the place where Petalinux are installed. 
It expects them in /opt/Xilinx/Petalinux/$VERSION/
The plnx-docker-export contains some enviornment variables which are needed to be set correctly.

## default image (Dockerfile and docer-compose.yml):
It loads a image with all the nessasay steps which is needed to mirror the user id/enviornemnt and others
to ensure that the docker works seemlessly. only one image is created for all users.
Firstly, create the image from anywhere using the following command: docker build -t petalnx-ubuntu16 . 
Upate the enviornments tp reflect your host machine. Than copy the yml files into your petalinux workspace 
and run: 

'''docker-compose run --rm plnx "/bin/bash"  '''

OR whatever command you wish to run

## The docker-compose_usr.yml 
It requires firstly to create the original image Dockerfile_orig. following that, the subsequent image containing 
the user profile is created from dockerr-compose

#!/bin/bash

docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v myautority:/root/.Xauthority -v /home/andrei/NetBeansProjects:/home/andrei/NetBeansProjects -v /home/andrei/.netbeans:/home/andrei/.netbeans netbeans:latest
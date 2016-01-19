FROM alpine:latest
MAINTAINER tyler@linux.com


RUN apk update
# Get the necessary dependencies to build our mdp installation
RUN apk add git make gcc binutils libc-dev ncurses-dev
# Grab mdp for building
RUN git clone https://github.com/visit1985/mdp.git
RUN cd mdp && make && make install

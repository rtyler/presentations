FROM alpine:3.3
MAINTAINER tyler@linux.com


# Get the necessary dependencies to build our mdp installation
RUN apk update && apk add --no-cache git make gcc binutils libc-dev ncurses-dev
# Grab mdp for building
RUN git clone --depth=1 https://github.com/visit1985/mdp.git

WORKDIR mdp
RUN make && make install
WORKDIR /

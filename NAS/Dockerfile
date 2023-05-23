FROM docker.io/ubuntu:22.04

# Point to MPI binaries, libraries, man pages
ENV MPI_DIR=/opt/mpich
ENV UCX_DIR=/opt/ucx
ENV PATH="$UCX_DIR/bin:$MPI_DIR/bin:$PATH"
ENV LD_LIBRARY_PATH="$UCX_DIR/lib:$MPI_DIR/lib:$LD_LIBRARY_PATH"
ENV MANPATH="$MPI_DIR/share/man:$MANPATH"
ENV MPI_VERSION=4.1.1
ENV MPI_URL="https://www.mpich.org/static/downloads/$MPI_VERSION/mpich-$MPI_VERSION.tar.gz"
ENV UCX_VERSION=1.14.0

RUN echo "Installing required packages..."
RUN apt-get update && apt-get install -y wget git bash gcc gfortran g++ make file libnuma-dev libpmi2-0-dev python3
RUN mkdir -p /opt

# Install UCX
RUN echo "Installing UCX"
RUN mkdir -p /tmp/ucx
RUN cd /tmp/ucx && wget https://github.com/openucx/ucx/releases/download/v$UCX_VERSION/ucx-$UCX_VERSION.tar.gz && tar xzf ucx-$UCX_VERSION.tar.gz
RUN cd /tmp/ucx/ucx-$UCX_VERSION && ./configure --prefix=$UCX_DIR && make -j6 && make install

RUN mkdir -p /tmp/mpich
# Download
RUN cd /tmp/mpich && wget -O mpich-$MPI_VERSION.tar.gz $MPI_URL && tar -xzf mpich-$MPI_VERSION.tar.gz
# Compile and install
RUN cd /tmp/mpich/mpich-$MPI_VERSION && ./configure --prefix=$MPI_DIR --with-device=ch4:ucx --with-ucx=$UCX_DIR && make -j6 install


RUN echo "Build NAS"
COPY ./NPB3.4.2 /opt/NPB3.4.2
RUN cd /opt/NPB3.4.2/NPB3.4-MPI && make cg CLASS=C \
  && make bt CLASS=C \
  && make ft CLASS=C \
  && make lu CLASS=C \
  && make mg CLASS=C \
  && make sp CLASS=C

RUN chmod 777 /opt/NPB3.4.2/NPB3.4-MPI/bin/cg.C.x \
  && chmod 777 /opt/NPB3.4.2/NPB3.4-MPI/bin/bt.C.x \
  && chmod 777 /opt/NPB3.4.2/NPB3.4-MPI/bin/ft.C.x \
  && chmod 777 /opt/NPB3.4.2/NPB3.4-MPI/bin/lu.C.x \
  && chmod 777 /opt/NPB3.4.2/NPB3.4-MPI/bin/mg.C.x \
  && chmod 777 /opt/NPB3.4.2/NPB3.4-MPI/bin/sp.C.x

RUN chmod 777 /opt/NPB3.4.2/NPB3.4-MPI && chmod 777 /opt/NPB3.4.2/NPB3.4-MPI/bin



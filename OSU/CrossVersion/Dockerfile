FROM docker.io/ubuntu:22.04

# Point to MPI binaries, libraries, man pages
ENV MPI_DIR=/opt/mpich
ENV UCX_DIR=/opt/ucx
ENV PATH="$UCX_DIR/bin:$MPI_DIR/bin:$PATH"
ENV LD_LIBRARY_PATH="$UCX_DIR/lib:$MPI_DIR/lib:$LD_LIBRARY_PATH"
ENV MANPATH="$MPI_DIR/share/man:$MANPATH"
ENV MPI_VERSION=3.4.3
ENV MPI_URL="https://www.mpich.org/static/downloads/$MPI_VERSION/mpich-$MPI_VERSION.tar.gz"
ENV UCX_VERSION=

RUN echo "Installing required packages..."
RUN apt-get update && apt-get install -y wget git bash gcc gfortran g++ make file libnuma-dev libpmi2-0-dev 
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
RUN cd /tmp/mpich/mpich-$MPI_VERSION && ./configure --prefix=$MPI_DIR --disable-fortran --with-device=ch4:ucx --with-ucx=$UCX_DIR && make -j6 install

RUN echo "Build OSU"
RUN cd /opt && wget http://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-7.1-1.tar.gz && tar xzf osu-micro-benchmarks-7.1-1.tar.gz
RUN cd /opt/osu-micro-benchmarks-7.1-1 && ./configure --prefix=/opt  CC=$MPI_DIR/bin/mpicc CXX=$MPI_DIR/bin/mpicxx && make -j6 && make install
FROM docker.io/ubuntu:22.04

# Point to MPI binaries, libraries, man pages
ENV MPI_DIR=/opt/mpich
ENV PATH=":$MPI_DIR/bin:$PATH"
ENV LD_LIBRARY_PATH="/opt/intel_compiler/lib:$MPI_DIR/lib:$LD_LIBRARY_PATH"
ENV MANPATH="$MPI_DIR/share/man:$MANPATH"
ENV MPI_VERSION=4.1.1
ENV MPI_URL="https://www.mpich.org/static/downloads/$MPI_VERSION/mpich-$MPI_VERSION.tar.gz"

RUN echo "Installing required packages..."
RUN apt-get update && apt-get install -y wget git bash gcc gfortran g++ make file libnuma-dev libpmi2-0-dev 
RUN mkdir -p /opt

RUN mkdir -p /tmp/mpich
# Download
RUN cd /tmp/mpich && wget -O mpich-$MPI_VERSION.tar.gz $MPI_URL && tar -xzf mpich-$MPI_VERSION.tar.gz
# Compile and install
RUN cd /tmp/mpich/mpich-$MPI_VERSION && ./configure --prefix=$MPI_DIR --disable-fortran && make -j6 install

RUN echo "Build OSU"
RUN cd /opt && wget http://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-7.1-1.tar.gz && tar xzf osu-micro-benchmarks-7.1-1.tar.gz
RUN cd /opt/osu-micro-benchmarks-7.1-1 && ./configure --prefix=/opt  CC=$MPI_DIR/bin/mpicc CXX=$MPI_DIR/bin/mpicxx && make -j6 && make install
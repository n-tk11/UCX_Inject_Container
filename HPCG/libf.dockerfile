FROM docker.io/ubuntu:22.04

# Point to MPI binaries, libraries, man pages
ENV MPI_DIR=/opt/mpich
ENV LIBF_DIR=/opt/libf
ENV PATH="$LIBF_DIR/bin:$MPI_DIR/bin:$PATH"
ENV LD_LIBRARY_PATH="$LIBF_DIR/lib:$MPI_DIR/lib:$LD_LIBRARY_PATH"
ENV MANPATH="$MPI_DIR/share/man:$MANPATH"
ENV MPI_VERSION=4.1.1
ENV MPI_URL="https://www.mpich.org/static/downloads/$MPI_VERSION/mpich-$MPI_VERSION.tar.gz"
ENV LIBF_VERSION=1.18.0

RUN echo "Installing required packages..."
RUN apt-get update && apt-get install -y wget git bash gcc gfortran g++ make file libnuma-dev libpmi2-0-dev autoconf automake libtool
RUN mkdir -p /opt

# Install Libfabric
RUN echo "Installing Libfabric"
RUN mkdir -p /tmp/libf
RUN cd /tmp/libf && wget https://github.com/ofiwg/libfabric/archive/refs/tags/v$LIBF_VERSION.tar.gz && tar xzf v$LIBF_VERSION.tar.gz
RUN cd /tmp/libf/libfabric-$LIBF_VERSION && ./autogen.sh && ./configure --prefix=$LIBF_DIR --enable-efa=no && make -j6 && make install

RUN mkdir -p /tmp/mpich
# Download
RUN cd /tmp/mpich && wget -O mpich-$MPI_VERSION.tar.gz $MPI_URL && tar -xzf mpich-$MPI_VERSION.tar.gz
# Compile and install
RUN cd /tmp/mpich/mpich-$MPI_VERSION && ./configure --prefix=$MPI_DIR --disable-fortran --with-device=ch4:ofi --with-libfabric=$LIBF_DIR && make -j6 install

RUN echo "Build HPCG"
COPY ./hpcg-3.1 /opt/hpcg-3.1
RUN cd /opt/hpcg-3.1 && make arch=libf
FROM ubuntu:18.04
WORKDIR /root

# essential libraries
RUN apt update && apt install -y golang software-properties-common build-essential autoconf libtool automake curl unzip git g++ gcc cmake libssl-dev libz-dev pkg-config libgtest-dev libboost-all-dev && apt-get clean

# build GTest
RUN cd /usr/src/gtest && mkdir build && cd build && cmake .. && make -j8 && make install

# build protobuf & grpc
RUN cd /usr/src/ && git clone -b "v1.19.x" https://github.com/grpc/grpc && cd grpc && \
    git submodule update --init && \
    cd third_party/protobuf && \
    mkdir _build && cd _build && cmake ../cmake -Dprotobuf_BUILD_TESTS=OFF -DCMAKE_BUILD_TYPE=RelWithDebInfo && make -j$(nproc) && make install && make clean && cd ../../.. && \
    cd third_party/cares/cares && \
    mkdir _build && cd _build && cmake .. -DCMAKE_BUILD_TYPE=RelWithDebInfo && make -j$(nproc) && make install && make clean && cd ../../../.. && \
    mkdir _build && cd _build && cmake .. -DCMAKE_BUILD_TYPE=RelWithDebInfo -DgRPC_ZLIB_PROVIDER=package -DgRPC_CARES_PROVIDER=package -DgRPC_SSL_PROVIDER=package -DgRPC_PROTOBUF_PROVIDER=package && make -j$(nproc) && make install && make clean

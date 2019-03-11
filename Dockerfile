FROM ubuntu:18.04
WORKDIR /root

RUN apt update
RUN apt install -y git g++ gcc cmake libssl-dev libgrpc++-dev libz-dev pkg-config libgtest-dev libboost-all-dev libprotobuf-dev protobuf-compiler libprotoc-dev

# build GTest
RUN cd /usr/src/gtest && mkdir build && cd build && cmake .. && make -j8 && make install

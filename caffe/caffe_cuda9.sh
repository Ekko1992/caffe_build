#!/bin/bash
#1 install essential tools
sudo apt-get install -y git
sudo apt-get install -y python-pip
sudo pip install --upgrade pip
sudo apt-get install -y python-numpy
sudo apt-get install -y --no-install-recommends libboost-all-dev
sudo apt-get install -y libatlas-base-dev
sudo apt-get install -y python-dev
sudo apt-get install -y libgflags-dev libgoogle-glog-dev liblmdb-dev
sudo apt-get install -y build-essential
sudo apt-get install -y cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
sudo apt-get install -y libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev
sudo apt-get install -y libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev protobuf-compiler
sudo apt-get install -y libhdf5-serial-dev

#2 install cuda
wget https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda-repo-ubuntu1604-9-0-local_9.0.176-1_amd64-deb
sudo dpkg -i cuda-repo-ubuntu1604-9-0-local_9.0.176-1_amd64-deb
sudo apt-key add /var/cuda-repo-9-0-local/7fa2af80.pub
sudo apt-get update
sudo apt-get install -y cuda
sudo sh -c 'echo "export PATH=/usr/local/cuda-9.0/bin:\$PATH" >> ~/.bashrc'
sudo sh -c 'echo "export LD_LIBRARY_PATH=/usr/local/cuda-9.0/lib64:\$LD_LIBRARY_PATH" >> ~/.bashrc'
source ~/.bashrc

#3 install cudnn
wget https://vmaxx.blob.core.windows.net/public/cudnn-9.0-linux-x64-v7.tgz
tar -xzvf cudnn-9.0-linux-x64-v7.tgz
sudo cp cuda/include/cudnn.h /usr/local/cuda/include
sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*

#4 install opencv
git clone http://github.com/opencv/opencv.git
cd opencv
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr/local ..
make -j8
sudo make install
cd ../../

#5 install caffe
git clone https://github.com/BVLC/caffe.git
cp Makefile.config caffe/
cd caffe
for req in $(cat python/requirements.txt); do sudo pip install $req; done
mkdir build
cd build
cmake ..
make all
make install

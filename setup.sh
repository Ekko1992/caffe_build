#!/bin/bash
#script for cuda 8.0 + opencv 2.4.13 + cudnn + caffe installation
#suitable for linux ubuntu 16.04 with gtx-1080 graphics card

#1 install necessary tools
sudo apt-get install -y unzip
sudo apt-get install -y axel
sudo apt-get install -y g++
sudo apt-get install -y git
sudo apt-get install -y freeglut3-dev
sudo apt-get install -y build-essential libgtk2.0-dev libavcodec-dev libavformat-dev libjpeg.dev libtiff4.dev libswscale-dev libjasper-dev
sudo apt-get install -y cmake

#configure locale
sudo sh -c 'echo "export LC_ALL="en_US.UTF-8" >> /etc/profile'
sudo sh -c 'echo "export LC_CTYPE="en_US.UTF-8" >> /etc/profile'
source /etc/profile
sudo dpkg-reconfigure locales

#2 download cuda 8.0
axel https://s3-us-west-2.amazonaws.com/vmaxx1/caffesetup/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
#install cuda
sudo dpkg -i cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
sudo apt-get update
sudo apt-get install -y cuda
#add cuda to path
sudo sh -c 'echo "export PATH=/usr/local/cuda-8.0/bin:\$PATH" >> /etc/profile'
sudo sh -c 'echo "export LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64:\$LD_LIBRARY_PATH" >> /etc/profile'
source /etc/profile

#3 ban nouveau driver
sudo sh -c 'echo "blacklist nouveau" >> /etc/modprobe.d/blacklist-nouveau.conf'
sudo sh -c 'echo "options nouveau modset=0" >> /etc/modprobe.d/blacklist-nouveau.conf'
#sudo update-initramfs -u

#4 download and install caffe
git clone https://github.com/BVLC/caffe.git
#install third-party libriaries
sudo apt-get install -y libatlas-base-dev
sudo apt-get install -y libprotobuf-dev
sudo apt-get install -y libleveldb-dev
sudo apt-get install -y libsnappy-dev
sudo apt-get install -y libopencv-dev
sudo apt-get install -y libboost-all-dev
sudo apt-get install -y libhdf5-serial-dev
sudo apt-get install -y libgflags-dev
sudo apt-get install -y libgoogle-glog-dev
sudo apt-get install -y liblmdb-dev
sudo apt-get install -y protobuf-compiler

#5 download and install opencv
axel https://s3-us-west-2.amazonaws.com/vmaxx1/caffesetup/opencv-2.4.13.zip
unzip opencv-2.4.13.zip
cd opencv-2.4.13
cmake .
make -j8
sudo make install
#set up configuration for opencv
sudo sh -c 'echo "/usr/local/lib" >> /etc/ld.so.conf.d/opencv.conf'
sudo ldconfig
sudo sh -c 'echo "PKG_CONFIG_PATH=\$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig" >> /etc/bash.bashrc'
sudo sh -c 'echo "export PKG_CONFIG_PATH" >> /etc/bash.bashrc'
source /etc/bash.bashrc
sudo updatedb

#6 install cudnn
cd ..
axel https://s3-us-west-2.amazonaws.com/vmaxx1/caffesetup/cudnn-8.0-linux-x64-v5.1.tgz
sudo tar xvf cudnn-8.0-linux-x64-v5.1.tgz
sudo cp cuda/include/*.h /usr/local/include/
sudo cp cuda/lib64/lib* /usr/local/lib/
sudo chmod +r /usr/local/lib/libcudnn.so.5.1.10
sudo ln -sf /usr/local/lib/libcudnn.so.5.1.10 /usr/local/lib/libcudnn.so.5
sudo ln -sf /usr/local/lib/libcudnn.so.5 /usr/local/lib/libcudnn.so
sudo ldconfig

#7 caffe python interface
#7.1 install pip
cd caffe

sudo apt-get install -y python-pip python-dev build-essential
sudo pip install --upgrade pip
sudo apt-get install -y python-numpy
sudo apt-get install -y python-numpy python-scipy python-matplotlib python-sklearn python-skimage python-h5py python-protobuf python-leveldb python-networkx python-nose python-pandas python-gflags cython ipython

#7.2 install dependent libraries
sudo apt-get install gfortran
for req in $(cat python/requirements.txt); do sudo -H pip install $req; done
sudo pip install -r python/requirements.txt

#7.3 compile python interface
sudo sh -c 'echo "export PYTHONPATH=`pwd`:\$PYTHONPATH" >> ~/.bashrc'
sudo ldconfig
source ~/.bashrc


#8 compile caffe
axel https://s3-us-west-2.amazonaws.com/vmaxx1/caffesetup/Makefile.config
make all -j4
make pycaffe -j4
sudo sh -c 'echo "/usr/local/cuda/lib64" >> /etc/ld.so.conf.d/caffe.conf'
sudo ldconfig








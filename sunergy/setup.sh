#!/bin/bash
#1 install essential tools
sudo apt-get install -y git
sudo apt-get install -y python-pip
sudo apt-get install -y python-numpy


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

#4 compile Sunergy
git clone https://github.com/VMaxxInc/Sunergy_linux.git
cd Sunergy
make
cd ../Sunergy_linux/PySunergy
make


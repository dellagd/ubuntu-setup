#!/bin/sh

#Install script for gnuradio on 16.04

#Current Directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

#Get suggested build threads
echo How many build threads should be used?
read BUILD_THREADS

#Setup bashrc
echo 'export PATH=$HOME/usr/bin:$PATH' >> ~/.bashrc 
echo 'export LD_LIBRARY_PATH=$HOME/usr/lib:$LD_LIBRARY_PATH' >> ~/.bashrc 
echo 'export PYTHONPATH=$HOME/usr/lib/python2.7/dist-packages/:$LD_LIBRARY_PATH' >> ~/.bashrc 
exit 1

#Install Packages
sudo apt -y install git-core git cmake g++ python-dev swig \
pkg-config libfftw3-dev libboost-all-dev libcppunit-dev libgsl0-dev \
libusb-dev libsdl1.2-dev python-wxgtk3.0 python-numpy \
python-cheetah python-lxml doxygen libxi-dev python-sip \
libqt4-opengl-dev libqwt-dev libfontconfig1-dev libxrender-dev \
python-sip python-sip-dev python-qt4 python-sphinx libusb-1.0-0-dev \
libcomedi-dev libzmq-dev python-mako python-gtk2 lsb-core libglfw3 libglfw3-dev

#Install HackRF
cd $DIR
git clone https://github.com/mossmann/hackrf.git
cd hackrf
cd host
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=~/usr ..
make -j4
sudo make install

#Install RTLSDR
cd $DIR
git clone https://github.com/steve-m/librtlsdr.git
cd librtlsdr
git checkout 0.6.0
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=~/usr ..
make -j4
sudo make install

#Install opencl runtime
cd $DIR
wget http://registrationcenter-download.intel.com/akdlm/irc_nas/vcp/15532/l_opencl_p_18.1.0.015.tgz
tar xzvf l_opencl_p_18.1.0.015.tgz
rm l_opencl_p_18.1.0.015.tgz
cd l_opencl_p_18.1.0.015
sudo ./install.sh

#Install header shared library
sudo apt install ocl-icd-opencl-dev

#Setup install dir
mkdir ~/usr

#Install UHD
cd $DIR
git clone https://github.com/EttusResearch/uhd.git --recursive
cd uhd
git checkout UHD-3.9.LTS
git submodule update
cd host
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=~/usr ..
make -j$BUILD_THREADS
make install

#Install Gnurdio
cd $DIR
git clone https://github.com/gnuradio/gnuradio.git --recursive
cd gnuradio
git checkout v3.7.14.0
git submodule update
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=~/usr ..
make -j$BUILD_THREADS
make install

#Install fosphor
cd $DIR
git clone https://github.com/osmocom/gr-fosphor.git
cd gr-fosphor
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=~/usr ..
make -j$BUILD_THREADS
make install

#Install OsmoSDR
cd $DIR
git clone https://github.com/osmocom/gr-osmosdr.git
cd gr-osmosdr
git checkout gr3.7
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=~/usr ..
make -j$BUILD_THREADS
make install

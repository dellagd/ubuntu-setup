#!/bin/bash

#Get suggested build threads
echo How many build threads should be used?
read BUILD_THREADS

# Install Prerequisites
sudo apt install git cmake g++ libboost-all-dev libgmp-dev swig python3-numpy python3-mako python3-sphinx python3-lxml doxygen libfftw3-dev libsdl1.2-dev libgsl-dev libqwt-qt5-dev libqt5opengl5-dev python3-pyqt5 liblog4cpp5-dev libzmq3-dev python3-yaml python3-click python3-click-plugins python3-zmq python3-scipy python3-gi python3-gi-cairo gobject-introspection gir1.2-gtk-3.0 libusb-1.0-0-dev lsb-core libfreetype-dev

# Setup bashrc
echo 'export PATH=$HOME/usr/bin:$PATH' >> ~/.bashrc 
echo 'export LD_LIBRARY_PATH=$HOME/usr/lib:$LD_LIBRARY_PATH' >> ~/.bashrc 
echo 'export PYTHONPATH=$HOME/usr/lib/python3/dist-packages/:$LD_LIBRARY_PATH' >> ~/.bashrc 

# Make usr directory
cd ~
mkdir usr

# Change to install dir
cd ~
mkdir GNURadioInstall
cd GNURadioInstall

# Install Volk
cd ~/GNURadioInstall
git clone --recursive https://github.com/gnuradio/volk.git
cd volk
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=~/usr -DCMAKE_BUILD_TYPE=Release -DPYTHON_EXECUTABLE=/usr/bin/python3 ../
make -j$BUILD_THREADS
make test
make install

# Install GNURadio
cd ~/GNURadioInstall
git clone https://github.com/gnuradio/gnuradio.git
cd gnuradio
git checkout v3.8.2.0
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=~/usr -DCMAKE_BUILD_TYPE=Release -DENABLE_INTERNAL_VOLK=OFF -DPYTHON_EXECUTABLE=/usr/bin/python3 ../
make -j$BUILD_THREADS
make test
make install

# Install bladeRF
cd ~
git clone https://github.com/Nuand/bladeRF.git
cd bladeRF/host
cmake -DCMAKE_INSTALL_PREFIX=~/usr ..
make -j$BUILD_THREADS
# sudo required to install rules
sudo make install

# Install osmosdr
cd ~/GNURadioInstall
git clone git://git.osmocom.org/gr-osmosdr
cd gr-osmosdr
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=~/usr ..
make -j$BUILD_THREADS
make install

#Install opencl runtime
cd ~/GNURadioInstall
wget http://registrationcenter-download.intel.com/akdlm/irc_nas/vcp/15532/l_opencl_p_18.1.0.015.tgz
tar xzvf l_opencl_p_18.1.0.015.tgz
rm l_opencl_p_18.1.0.015.tgz
cd l_opencl_p_18.1.0.015
sudo ./install.sh

#Install header shared library
sudo apt install ocl-icd-opencl-dev

#Install fosphor
cd ~/GNURadioInstall
git clone https://github.com/osmocom/gr-fosphor.git
cd gr-fosphor
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=~/usr ..
make -j$BUILD_THREADS
make install


## Kaldi Pop Up Archive Image
FROM ubuntu:16.10
MAINTAINER Steve McLaughlin <stephen.mclaughlin@utexas.edu>

ENV PYTHONWARNINGS="ignore:a true SSLContext object"
ENV SHELL /bin/bash

## Installing core system dependencies
RUN apt-get update && \
apt-get install -y \
g++ zlib1g-dev make automake libtool-bin git autoconf build-essential && \
apt-get install -y \
software-properties-common subversion libatlas3-base bzip2 wget curl gawk \
zip unzip libperl4-corelibs-perl libjson-perl python2.7 && \
ln -s -f bash /bin/sh

## Installing older C/C++ compilers
RUN apt-get update && \
apt-get install -y gcc-4.8 g++-4.8 libgcc-4.8-dev && \
alias gcc='gcc-4.8' && alias cc='gcc-4.8' && \
alias g++='g++-4.8' && alias c++='c++-4.8'

## Installing Perl dependencies
RUN curl -L http://cpanmin.us | perl - App::cpanminus && cpanm File::Slurp::Tiny Data::Dump

## Setting UTF-8 as default encoding format for terminal
RUN apt-get install -y language-pack-en
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

## Installing FFmpeg and SoX
RUN add-apt-repository ppa:jonathonf/ffmpeg-3 && apt -y update \
&& apt install -y ffmpeg libav-tools x264 x265
RUN apt-get update && apt-get install -y \
sox libsox-fmt-alsa libsox-fmt-base libsox2

## Downloading Kaldi & Kaldi PUA resources
RUN git clone https://github.com/kaldi-asr/kaldi.git kaldi --origin upstream && \
cd /kaldi/ && git clone https://github.com/popuparchive/american-archive-kaldi && \
cd /kaldi/american-archive-kaldi/sample_experiment/ && \
wget https://sourceforge.net/projects/popuparchive-kaldi/files/exp2.tar.gz && \
tar -xvzf exp2.tar.gz && \
mv exp2 exp


## Install sctk
RUN apt-get update && apt-get install -y sctk

#RUN cd /kaldi/tools/ && rm -rf sctk-2.4.10
#RUN wget http://www.openslr.org/resources/4/sctk-2.4.10-20151007-1312Z.tar.bz2 && \
#tar jxf sctk-2.4.10-20151007-1312Z.tar.bz2 && \
#cd sctk-2.4.10 && \
#make config && \
#make all && \
#make check && \
#make install && \
#make doc && \


#### Don't touch above this line. ####

## fork of Dockerized speech recognition with Kaldi + Pop Up Archive models
FROM ubuntu:18.04
MAINTAINER Keigh Rim <krim@brandeis.edu>

ENV PYTHONWARNINGS="ignore:a true SSLContext object"
ENV SHELL /bin/bash

## Installing core system dependencies
RUN apt-get update && \
apt-get install -y \
g++ zlib1g-dev make automake autoconf libtool-bin git build-essential && \
apt-get install -y \
software-properties-common subversion libatlas3-base bzip2 wget curl gawk \
zip unzip libperl4-corelibs-perl libjson-perl python2.7 python-pip && \
pip install -U ftfy==4.4.3 && \
ln -s -f bash /bin/sh

## Installing old C/C++ compilers
RUN apt-get update && \
apt-get install -y gcc-4.8 g++-4.8 libgcc-4.8-dev && \
alias gcc='gcc-4.8' && alias cc='gcc-4.8' && \
alias g++='g++-4.8' && alias c++='c++-4.8'

## Installing Perl dependencies
RUN curl -L http://cpanmin.us | perl - App::cpanminus && cpanm File::Slurp::Tiny Data::Dump

## Installing sclite
RUN apt-get update && apt-get install -y sctk && \
alias sclite="sctk sclite"

## Setting UTF-8 as default encoding format for terminal
RUN apt-get install -y language-pack-en
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

## Downloading Kaldi and PUA resources
RUN git clone https://github.com/kaldi-asr/kaldi.git kaldi --origin upstream
ADD aapb-popup-kaldi-recipe /kaldi/egs/american-archive-kaldi/
ADD exp2.tar.gz /kaldi/egs/american-archive-kaldi/sample_experiment/

## Creating expected symlinks
RUN ln -s /kaldi/egs/wsj/s5/steps /kaldi/egs/american-archive-kaldi/sample_experiment/exp && \
ln -s /kaldi/egs/wsj/s5/utils /kaldi/egs/american-archive-kaldi/sample_experiment/exp && \
ln -s /kaldi/egs/wsj/s5/steps /kaldi/egs/american-archive-kaldi/sample_experiment/ && \
ln -s /kaldi/egs/wsj/s5/utils /kaldi/egs/american-archive-kaldi/sample_experiment/

## Installing SoX and FFmpeg
RUN apt-get update && apt-get install -y \
sox libsox-dev ffmpeg

## Compiling Kaldi
RUN apt install -y libatlas-base-dev
RUN cd /kaldi/tools && make -j 8 && \
cd /kaldi/src && ./configure && make depend && make -j 8

## Installing pip and ftfy
RUN apt-get update && apt-get install -y python-pip && \
pip install ftfy==4.4.3 && \
alias python=python2.7

## Installing IRSTLM
RUN apt-get update && apt-get install -y cmake irstlm

## Installing editors
RUN apt-get update && apt-get install -y nano vim 

## Installing CMUseg
RUN cd /kaldi/egs/american-archive-kaldi/sample_experiment/ && \
sh install-cmuseg.sh && \
chmod -R 755 ./tools/CMUseg_0.5/bin/linux/

## Configuration tweaks
COPY scripts/run.pl /kaldi/egs/wsj/s5/utils/
RUN mkdir /audio_in

WORKDIR /audio_in

## Plans for next iteration
# Pass local directory pathname as a shared volume in docker run command, then launch setup.sh as CMD or ENTRYPOINT.
# Handle troublesome filename characters by quoting arguments in run.sh ... or just remove them.
# Set nj prefs in a yaml file or some such.

# Transcript output location: /kaldi/egs/american-archive-kaldi/sample_experiment/output

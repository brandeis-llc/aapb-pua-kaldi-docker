## fork of Dockerized speech recognition with Kaldi + Pop Up Archive models
FROM kaldi/kaldi-debian:latest
MAINTAINER Keigh Rim <krim@brandeis.edu>

ENV PYTHONWARNINGS="ignore:a true SSLContext object"
ENV SHELL=/bin/bash
ENV KALDI_ROOT="/opt/kaldi"
ENV AAPB_PUA_RECIPE="${KALDI_ROOT}/egs/american-archive-kaldi"

## Installing core system dependencies
RUN apt-get update && \
    apt-get install -y \
        software-properties-common curl gawk zip unzip libperl4-corelibs-perl \
        libjson-perl python2.7 python-pip libsox-dev ffmpeg vim nano rsync
# set python and python dependencies
RUN pip install -U ftfy==4.4.3
RUN alias python=python2.7
RUN ln -s -f bash /bin/sh

## Installing old C/C++ compilers
# RUN apt-get install -y gcc-4.8 g++-4.8 libgcc-4.8-dev
# RUN alias gcc='gcc-4.8' && alias cc='gcc-4.8' && alias g++='g++-4.8' && alias c++='c++-4.8'

## Installing Perl dependencies
RUN curl -L http://cpanmin.us | perl - App::cpanminus && cpanm File::Slurp::Tiny Data::Dump

## Installing sclite
RUN apt-get install -y sctk
RUN alias sclite="sctk sclite"

## Setting UTF-8 as default encoding format for terminal
RUN apt-get install -y locales locales-all
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

## copy PUA resources
ADD recipe $KALDI_ROOT/egs/american-archive-kaldi/
ADD exp2.tar.gz $KALDI_ROOT/egs/american-archive-kaldi/sample_experiment/

## Creating expected symlinks
RUN ln -s $KALDI_ROOT/egs/wsj/s5/steps $AAPB_PUA_RECIPE/sample_experiment/exp && \
ln -s $KALDI_ROOT/egs/wsj/s5/utils $AAPB_PUA_RECIPE/sample_experiment/exp && \
ln -s $KALDI_ROOT/egs/wsj/s5/steps $AAPB_PUA_RECIPE/sample_experiment/ && \
ln -s $KALDI_ROOT/egs/wsj/s5/utils $AAPB_PUA_RECIPE/sample_experiment/

## Installing IRSTLM
RUN apt-get install -y cmake irstlm

## Installing CMUseg
RUN cd $AAPB_PUA_RECIPE/sample_experiment/ && \
sh install-cmuseg.sh && \
chmod -R 755 ./tools/CMUseg_0.5/bin/linux/

# set working directory and batch script
RUN mkdir /audio_in
ADD run-kaldi.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/run-kaldi.sh 
WORKDIR /audio_in

CMD /bin/bash /usr/local/bin/run-kaldi.sh

## Plans for next iteration
# Pass local directory pathname as a shared volume in docker run command, then launch setup.sh as CMD or ENTRYPOINT.
# Handle troublesome filename characters by quoting arguments in run.sh ... or just remove them.
# Set nj prefs in a yaml file or some such.

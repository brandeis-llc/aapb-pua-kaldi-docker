#! /bin/bash 

if [ ! -e exp2.tar.gz ] ||  ! sha1sum -c exp2.tar.gz.sha1 ; then 
    rm exp2.tar.gz 2> /dev/null
    wget https://sourceforge.net/projects/popuparchive-kaldi/files/exp2.tar.gz
fi

docker build . -t brandeisllc/aapb-pua-kaldi:v1

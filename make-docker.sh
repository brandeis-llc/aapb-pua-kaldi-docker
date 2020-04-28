#! /bin/bash 
KALDI_DOCKERFILE="https://raw.githubusercontent.com/kaldi-asr/kaldi/master/docker/debian9.8-cpu/Dockerfile"

# get latest commit id from official kaldi repo
wget -O - https://api.github.com/repos/kaldi-asr/kaldi/git/refs/heads/master 2>/dev/null  \
    | grep "sha" | cut -d : -f 2 | cut -d \" -f 2 > kaldi-version

KALDI_DOCKER_NAME="kaldi/kaldi-debian"
KALDI_DOCKER_VER=`cat kaldi-version | cut -c 1-6`
KALDI_DOCKER_TAG=${KALDI_DOCKER_NAME}:${KALDI_DOCKER_VER}

if [[ `docker images -q ${KALDI_DOCKER_NAME} 2> /dev/null` = "" ]] ; then 
    # TODO: can be additional commits between querying github to get latest commit
    # and actually building the docker image (which just clone inside the image)
    wget -O - ${KALDI_DOCKERFILE} 2> /dev/null | \
        docker build -t ${KALDI_DOCKER_NAME} . -f - 
    docker tag ${KALDI_DOCKER_NAME} ${KALDI_DOCKER_TAG}
elif [[ `docker images -q ${KALDI_DOCKER_TAG} 2> /dev/null` = "" ]] ; then 
    echo "We found kaldi/kaldi-ubuntu docker image, " 
    echo "but it is using old version of the kaldi."
    echo "In case you want to have up-to-date kaldi in the image, "
    echo "you must remove the existing kaldi/kaldi-ubuntu image"
    echo "by using \`docker rmi\` command."
    echo ""
    echo "FOUND: $(docker images --format "{{.Tag}}" "$KALDI_DOCKER_NAME" | grep -v latest)"
    echo "LATEST: ${KALDI_DOCKER_VER}"
    echo "========================================================"
fi

if [ ! -e exp2.tar.gz ] ||  ! sha1sum -c exp2.tar.gz.sha1 ; then 
    rm exp2.tar.gz 2> /dev/null
    wget https://sourceforge.net/projects/popuparchive-kaldi/files/exp2.tar.gz
fi

docker build . -t aapb-pua-kaldi

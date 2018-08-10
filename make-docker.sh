if [ ! -d aapb-popup-kaldi-recipe ] ; then 
    git clone git@morbius.cs-i.brandeis.edu:wgbh/aapb-popup-kaldi-recipe.git
fi

if [ ! -e exp2.tar.gz ] ||  ! sha1sum -c exp2.tar.gz.sha1 ; then 
    rm exp2.tar.gz 
    wget https://sourceforge.net/projects/popuparchive-kaldi/files/exp2.tar.gz
fi

docker build . -t aapb-popup-kaldi:v1

#!/bin/bash

cd /audio_in/

## Now add media files to /audio_in/

for file in /audio_in/*.{wav,mp3,mp4,WAV,MP3,MP4}; do
base=$(basename "${file%.*}")
ffmpeg -i """$file""" -ac 1 -ar 16000 """$base"""_16kHz.wav;
done

mkdir /audio_in_16khz/
mv *_16kHz.wav /audio_in_16khz/

######### Starting the batch transcription run ##########

python $KALDI_ROOT/egs/american-archive-kaldi/run_kaldi.py $KALDI_ROOT/egs/american-archive-kaldi/sample_experiment/ /audio_in_16khz/ /audio_in && \
rsync -a $KALDI_ROOT/egs/american-archive-kaldi/sample_experiment/output/ /audio_in/transcripts/

rm -r /audio_in_16khz/

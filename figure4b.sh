#!/bin/bash
set -e

if [ ! -e $TOOLBOX_PATH/bart ] ; then
	echo "\$TOOLBOX_PATH is not set correctly!" >&2
	exit 1
fi
export PATH=$TOOLBOX_PATH:$PATH
export BART_COMPAT_VERSION="v0.4.04"

CALIB=24
KERN=6

DATA=data/slice-x3pf58r24
FULL=data/slice-full

bart caldir 24 ${FULL} sens_dir
./vcc_calib -k${KERN} -c0.85 -t0.001 -r${CALIB} ${DATA} sens

bart slice 4 0 sens sens0

# image reconstruction
bart pics -S -r0.001 ${DATA} sens0 reco_nocstr

bart pics -S -r0.001 -c ${DATA} sens0 reco_1map
bart pics -S -R R2:0:0.001 ${DATA} sens0 reco_l2

bart pics -S -r0.001 -c ${DATA} sens_dir reco_dir
bart pics -S -R R2:0:0.001 ${DATA} sens_dir reco_dir2

bart pics -S -r0.001 -c ${DATA} sens reco_2maps


# create difference of reweighted magnitude
bart fft -u -i 7 ${FULL} full_s
bart rss 8 full_s full_r
bart saxpy -- -1. full_r full_r full_diff

bart fmac -s16 reco_nocstr sens0 reco_nocstr_s
bart rss 8 reco_nocstr_s reco_nocstr_r
bart saxpy -- -1. reco_nocstr_r full_r reco_nocstr_diff

bart fmac -s16 reco_1map sens0 reco_1map_s
bart rss 8 reco_1map_s reco_1map_r
bart saxpy -- -1. reco_1map_r full_r reco_1map_diff

bart fmac -s16 reco_2maps sens reco_2maps_s
bart rss 8 reco_2maps_s reco_2maps_r
bart saxpy -- -1. reco_2maps_r full_r reco_2maps_diff

bart fmac -s16 reco_l2 sens0 reco_l2_s
bart rss 8 reco_l2_s reco_l2_r
bart saxpy -- -1. reco_l2_r full_r reco_l2_diff

bart fmac -s16 reco_dir sens_dir reco_dir_s
bart rss 8 reco_dir_s reco_dir_r
bart saxpy -- -1. reco_dir_r full_r reco_dir_diff

bart fmac -s16 reco_dir2 sens_dir reco_dir2_s
bart rss 8 reco_dir2_s reco_dir2_r
bart saxpy -- -1. reco_dir2_r full_r reco_dir2_diff

# create figure 4b
bart join 2 reco_l2_r reco_2maps_r reco_1map_r reco_dir2_r reco_dir_r reco_nocstr_r flp0
bart join 2 reco_l2_diff reco_2maps_diff reco_1map_diff reco_dir2_diff reco_dir_diff reco_nocstr_diff flp1
bart scale 5. flp1 flp1S
bart join 1 flp1S flp0 flp
bart flip 7 flp figure4b

rm reco_* full_* sens_dir.* sens.* sens0.* flp0.* flp1.* flp.* flp1S.*



#!/bin/bash
set -e

if [ ! -e $TOOLBOX_PATH/bart ] ; then
	echo "\$TOOLBOX_PATH is not set correctly!" >&2
	exit 1
fi
export PATH=$TOOLBOX_PATH:$PATH
export BART_COMPAT_VERSION="v0.4.04"


DATA=../data/slice-full
CALIB=24
KERN=6

bart caldir ${CALIB} ${DATA} sens_lowres

bart ecalib -k${KERN} -r${CALIB} ${DATA} sens_ESP

for c in 16 24 32 40; do
	for k in 4 6 8 10; do

	../vcc_calib -k${k} -c0. -r$c ${DATA} sens_VCE${c}x${k}
	bart normalize 8 sens_VCE${c}x${k} sens_VCE${c}x${k}_norm
	bart slice 4 0 sens_VCE${c}x${k}_norm sens_VCE${c}x${k}_norm0
	../mapsproj -c ${DATA} sens_VCE${c}x${k}_norm proj_VCE${c}x${k}_norm
	../mapsproj -c ${DATA} sens_VCE${c}x${k}_norm0 proj_VCE${c}x${k}_norm0
	done
done


bart fft -i -u 7 ${DATA} coil_images
bart rss 8 coil_images rss

../mapsproj -c ${DATA} sens_lowres   proj_lowres
../mapsproj  ${DATA} sens_ESP proj_ESP

bart scale 0.2 rss rssS

bart join 2 proj_ESP proj_VCE${CALIB}x${KERN}_norm proj_VCE${CALIB}x${KERN}_norm0  rssS flp2
bart flip 7 flp2 figure3a

for CALIB in 40 32 24 16 ; do
	bart join 2 proj_VCE${CALIB}x10_norm proj_VCE${CALIB}x8_norm proj_VCE${CALIB}x6_norm proj_VCE${CALIB}x4_norm proj_${CALIB}_all
	bart join 2 proj_VCE${CALIB}x10_norm0 proj_VCE${CALIB}x8_norm0 proj_VCE${CALIB}x6_norm0 proj_VCE${CALIB}x4_norm0 proj_${CALIB}_all0
done

bart join 1 proj_40_all proj_32_all proj_24_all proj_16_all proj_all
bart join 1 proj_40_all0 proj_32_all0 proj_24_all0 proj_16_all proj_all0

bart flip 6 proj_all0 figure3b
bart flip 6 proj_all figure3c

rm proj_* sens_* coil_images.* rss.* flp2.* rssS.*





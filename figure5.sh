#!/bin/bash
set -e

CALIB=24
KERN=6

DATA=data/slice2-x3
FULL=data/slice2-full

# estimate sensitivities with VCC-ESPIRiT
./vcc_calib -k${KERN} -c0.85 -t0.001 -r${CALIB} ${DATA} sens

# extract first (0th) set of maps
bart slice 4 0 sens sens0

# reconstruction 1 map, 2 maps, 1 map + relaxed constraint
bart pics -S -r0.001 -c ${DATA} sens0 reco_1map
bart pics -S -r0.001 -c ${DATA} sens reco_2maps
bart pics -S -R R2:0:0.001 ${DATA} sens0 reco_l2


# compute difference of reweighted magnitude images
bart fft -u -i 7 ${FULL} full_s
bart rss 8 full_s full_r
bart saxpy -- -1. full_r full_r full_diff

bart fmac -s16 reco_1map sens0 pfppi_1map_s
bart rss 8 reco_1map_s pfppi_1map_r
bart saxpy -- -1. reco_1map_r full_r pfppi_1map_diff

bart fmac -s16 reco_2maps sens pfppi_2maps_s
bart rss 8 reco_2maps_s pfppi_2maps_r
bart saxpy -- -1. reco_2maps_r full_r pfppi_2maps_diff

bart fmac -s16 reco_l2 sens0 pfppi_l2_s
bart rss 8 reco_l2_s pfppi_l2_r
bart saxpy -- -1. reco_l2_r full_r pfppi_l2_diff


# create figure 5
bart join 2  reco_l2_r pfppi_2maps_r pfppi_1map_r full_r flp0
bart join 2 reco_l2_diff pfppi_2maps_diff pfppi_1map_diff full_diff flp1
bart scale 5. flp1 flp1S
bart join 1 flp1S flp0 flp
bart flip 7 flp figure5

rm reco_* full_* sens.* sens0.* flp0.* flp1.* flp.* flp1S.*



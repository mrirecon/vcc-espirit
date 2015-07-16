
DATA=data/slice-full

caldir 24 ${DATA} sens_lowres

ecalib ${DATA} sens_ESP

./vcc_calib -k8 -c0. -r24 ${DATA} sens_VCE
normalize 8 sens_VCE sens_VCE_norm
slice 4 0 sens_VCE_norm sens_VCE_norm0

./vcc_calib -k8 -c0. -r40 ${DATA} sens_VCE40
normalize 8 sens_VCE40 sens_VCE40_norm
slice 4 0 sens_VCE40_norm sens_VCE40_norm0

fft -i -u 7 ${DATA} coil_images
rss 8 coil_images rss
./mapsproj -c ${DATA} sens_VCE_norm proj_VCE_norm
./mapsproj -c ${DATA} sens_VCE40_norm proj_VCE40_norm
./mapsproj -c ${DATA} sens_lowres   proj_lowres
./mapsproj -c ${DATA} sens_VCE_norm0 proj_VCE_norm0
./mapsproj -c ${DATA} sens_VCE40_norm0 proj_VCE40_norm0
./mapsproj  ${DATA} sens_ESP proj_ESP

#join 4 rss proj_VCE_norm0 proj_VCE40_norm0 proj_VCE_norm proj_VCE40_norm proj_ESP flp
join 4 proj_VCE_norm0 proj_VCE40_norm0 rss proj_VCE_norm proj_VCE40_norm proj_ESP  flp
flip 7 flp figure3

rm proj_* sens_* coil_images.* rss.* flp.*

# ------------




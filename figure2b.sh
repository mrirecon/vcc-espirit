
# VCC-ESPIRiT calibration
./vcc_calib -k8 -c0.75 data/slice-full sens_maps

# extract first to set of maps
slice 4 0 sens_maps sens_maps0
slice 4 1 sens_maps sens_maps1

# create coil images
fft -i -u 7 data/slice-full coil_images
scale 100. coil_images coil_images_scaled

# combine into one figure
join 4 coil_images_scaled sens_maps0 sens_maps1 flp

flip 7 flp figure2b_all

# extract first eight channels
extract 3 0 7 figure2b_all figure2b
rm flp.* sens_maps* coil_images* 




# VCC-ESPIRiT calibration
./vcc_calib -k6 -c0.85 -r24 data/slice-full sens_maps

# extract first to set of maps
bart slice 4 0 sens_maps sens_maps0
bart slice 4 1 sens_maps sens_maps1

# create coil images
bart fft -i -u 7 data/slice-full coil_images
bart scale 100. coil_images coil_images_scaled

# compute phase difference
bart fmac -C coil_images_scaled sens_maps0 phase
bart carg phase phase_diff


# combine into one figure and flip
bart join 4 coil_images_scaled phase_diff sens_maps0 sens_maps1 flp
bart flip 7 flp figure2b_all

# extract first eight channels
bart extract 3 0 8 figure2b_all figure2b


rm flp.* coil_images* phase.* phase_diff.* sens_maps*


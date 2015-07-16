
./vcc_calib -k8 -c0.75 -r40 data/slice-x3pf58r40 sens
slice 4 0 sens sens0

sense -S -r0.005 -c data/slice-x3pf58r40 sens0 pfppi_1map
sense -S -r0.005 -c data/slice-x3pf58r40 sens pfppi_2maps
sense -S -r0.005 data/slice-x3pf58r40 sens0 pfppi_nocstr

slice 4 0 pfppi_2maps pfppi_2maps0
join 4 pfppi_nocstr pfppi_1map pfppi_2maps0 flp
flip 7 flp figure4

rm pfppi_* sens.* sens0.* flp.*



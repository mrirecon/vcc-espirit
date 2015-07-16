

# create virtual conjugate channels
flip 7 data/slice-full tmp1
circshift 0 1 tmp1 tmp2
circshift 1 1 tmp2 tmp1
circshift 2 1 tmp1 tmp2
conj tmp2 vcc
rm tmp1.* tmp2.*

# combine real and virtual to one set
join 3 data/slice-full vcc both

# compute first eight maps (maps 8-63 are almost zero)
ecalib -r24 -k8 -c0. -m8 both sens flp

flip 7 flp figure2a

rm vcc.* both.* sens.* flp.*




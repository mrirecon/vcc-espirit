#!/bin/bash
set -e

if [ ! -e $TOOLBOX_PATH/bart ] ; then
	echo "\$TOOLBOX_PATH is not set correctly!" >&2
	exit 1
fi
export PATH=$TOOLBOX_PATH:$PATH
export BART_COMPAT_VERSION="v0.4.04"

# create virtual conjugate channels
bart flip 7 data/slice-full tmp1
bart circshift 0 1 tmp1 tmp2
bart circshift 1 1 tmp2 tmp1
bart circshift 2 1 tmp1 tmp2
bart conj tmp2 vcc
rm tmp1.* tmp2.*

# combine real and virtual to one set
bart join 3 data/slice-full vcc both

# compute first eight maps (maps 8-63 are almost zero)
bart ecalib -r24 -k6 -c0. -m8 both sens flp

# create figure 2a
bart flip 7 flp figure2a

rm vcc.* both.* sens.* flp.*




#!/bin/sh
for SQUARE in w b
do
	for PIECE in k q b r n p
	do
		convert b${PIECE}${SQUARE}.gif ${PIECE}${SQUARE}.png
		convert w${PIECE}${SQUARE}.gif $(echo $PIECE | tr '[:lower:]' '[:upper:]')${SQUARE}.png
	done
done

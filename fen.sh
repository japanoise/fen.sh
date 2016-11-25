#!/bin/sh
#Convert a FEN string into an image
COLOR='w'
RANK='8'
FENSHPRE="$(date +%s)-"

switchcolor() {
	if [ "$COLOR" = 'w' ]
	then
		COLOR='b'
	else
		COLOR='w'
	fi
}

puttile() {
	tileput="${2}${COLOR}.png"
	if [ "$RANK" = '1' ]
	then
		convert "$tileput" -background White \
		label:"$(echo $CHESSFILE | tr '123456789' 'abcdefghX')" \
		-gravity Center -append "1-$tileput"
		tileput="1-$tileput"
	fi
	if [ -f "$1" ]
	then
		cp "$1" "bak$1"
		convert "bak$1" "$tileput" +append "$1"
		rm "bak$1"
	else
		convert  -background White -resize '10' label:"$RANK" \
		-gravity West "$tileput" +append "$1"
	fi
	switchcolor
	CHESSFILE=$((CHESSFILE + 1))
}

if [ -z "$1" ]
then
	echo "Please provide a FEN string." >&2
	exit 1
fi

FEN=$(echo "$1" | sed -e 's/^  *//')
LOOPING=true
INDEX='1'
CHESSFILE='1'
while $LOOPING
do
	CHAR=$(echo $FEN | cut -c "$INDEX")
	echo $INDEX - $CHAR - $(echo $CHESSFILE | tr '123456789' 'abcdefghX')
	case "$CHAR" in
		[1-8])
			for i in $(seq 1 "$CHAR"); do
				puttile "${FENSHPRE}rank$RANK.png" 'e'
			done;;
		/)
			CHESSFILE=1
			RANK=$((RANK - 1))
			switchcolor;;
		[pPnNbBrRqQkK])
			puttile "${FENSHPRE}rank$RANK.png" "$CHAR";;
		*)
			LOOPING=false;;
	esac
	INDEX=$((INDEX + 1))
done

cp ${FENSHPRE}rank8.png ${FENSHPRE}result.png
for i in $(seq 1 7 | sort -r)
do
	cp ${FENSHPRE}result.png result.bak.png
	convert result.bak.png ${FENSHPRE}rank$i.png -append ${FENSHPRE}result.png
done
rm result.bak.png
rm ${FENSHPRE}rank*
rm 1-*.png

#!/bin/sh

# dirconvert -- convert the contents of a directory into a singular format

usage() {
	echo "usage: dirconvert.sh [-h] [-n new-format] [-o old directory] [-d new directory]"
	exit 1
}

if [ "$#" -lt 1 ]; then
	usage
fi

while getopts "f:ro:n:h" opt
do
	echo $OPTARG;
	case $opt in
		h) usage;; 
		f) FORMAT=$OPTARG;;
		o) OLD_DIR=$OPTARG;;
		n) NEW_DIR=$OPTARG;;
		*) usage;;
		:)
			case $OPTARG in
				f) echo '-f: file format required'; exit 1;;
				o) echo '-o: directory to convert required'; exit 1;;
			esac;;

	esac
done

cd "$OLD_DIR"
for i in * 
do
	newname=$(echo $i | awk -v e=$FORMAT -F. '{ $NF=""; print $0 FS e}' \
		| sed 's/ //g') 
	echo "$newname"
	# Select only the audio stream.
	ffmpeg -i "$i" -map 0:a "$newname"
done

cd -
mkdir "$NEW_DIR"
mv "$OLD_DIR"/*"$FORMAT" "$NEW_DIR" 

if [ $DELETEFLAG -n ]; then
fi

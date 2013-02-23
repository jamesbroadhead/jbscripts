#!/bin/bash

DEPLOY_FROM_DIR="$1"
bak="${HOME}/bak/$(date +%F)"

home_form() {
	# convert a <>/inside_dot_foo -> ~/.foo path
	home_form=$(echo "$1" | sed 's|.*dot_|'"$HOME"'/.|')
	echo ${home_form}
}

make_symlink() {
	# $1 : full path to a file which should be symlinked into ~
    dot_path="${1}"
	dot_name="$(basename ${1})"
	newpath=$(home_form $dot_path)
   	
	if [ -L "${newpath}" ] ; then 
		# broken symlink in place
		if ! [ -f "${newpath}" ] && [ -L "${newpath}" ] ; then 
			#echo "would remove $newpath"	
			rm "$newpath"
		# not a symlink pointing to the correct location
		elif ! [ "$(readlink ${newpath})" = "${dot_path}" ] ; then
			#echo "would replace $newpath"
			backup_old_content $newpath
		# there is a symlink pointing to the correct location already	
		else
			#echo "looks ok $newpath"	
			return 0
		fi
		
	elif [ -e "${newpath}" ] ; then
		#echo "would backup $newpath"	
		backup_old_content $newpath
	fi
	
	# there is no file or symlink at $newname already
	
	#echo "would link $newpath"
	mkdir -p $(dirname $newpath)
	ln -s "$dot_path" "$newpath"
}

# remove $1 from $HOME, so that a symlink can be created
backup_old_content() {
	# $1 filename in $HOME which should be moved to $bakpath
	path="$1"
	bakpath="$bak/$path"
	mkdir -p "$(dirname $bakpath)"
	echo "$path already existed! --> $bakpath"
	mv -i "$path" "${bakpath}"
}

confirmfile="$DEPLOY_FROM_DIR/.is_home_deploy_dir"
if ! [ -f $confirmfile ] ; then
	echo "Didn't find $confirmfile -- exiting"
	exit 1
fi

# cleanup from older versions
for e in $DEPLOY_FROM_DIR/* ; do
	base=$(basename $e)
	if [ -d $e ] && [ -L $HOME/$base ] ; then
		echo "Symlinks to deployable dirs exist in your homedir. Bailing"
	fi
done

for abspath in $(find "$1" -wholename "*dot_*" -type f -exec readlink -f {} \;) ; do
	make_symlink "${abspath}"
done

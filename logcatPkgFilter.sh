#!/bin/bash
if [[ ! -n $1 ]]; then
	cat <<EOF
	Usage: `basename $0` <PackageName>
EOF
	exit 1
fi
package_name=$1
pid_list=$(adb shell ps| grep $package_name)
if [[ -n $pid_list ]]; then
	# find pid, grep logcat with pid(s)
	#convert to egrep format
	pid_list=$(echo $pid_list|awk '{print $2}'|sed -r "s#(.*)#\\\(\[\ \]*\1\\\)#g"|tr '\n' '|')
	#strip the last '|'
	pid_list=${pid_list::-1}
	adb logcat | grep --color -E "$pid_list"
fi

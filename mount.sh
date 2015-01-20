#!/bin/bash
pwddir=$(pwd);
if [ -f "$pwddir/.mount" ];
then
	while read line           
	do           
    		IFS='=' read -a array <<< "$line";
		case "${array[0]}" in
    			project) fprojname="${array[1]}";;
    			user) fusername="${array[1]}";;
    			remotedir) fremotedir="${array[1]}";;
                        dir) fdir="${array[1]}";;
    			*) break;;
    		esac           
	done < "$pwddir/.mount"
fi
[ -z "${1}" ] && dir=$fdir || dir=${1};
dir="$pwddir/$dir";
[ -z "${2}" ] && projname=$fprojname || projname=${2};
[ -z "${3}" ] && username=$fusername || username=${3};
[ -z "${4}" ] && remotedir=$fremotedir || remotedir=${4};
if [ -z "$projname" ];
then
	IFS='/' read -a path <<< "$dir";
	projname=${path[*]: -3:1};
fi
if [ -z "$username" ];
then
	username='w3'$projname;
fi
if [ -d "$dir" ];
then
	command=( "sshfs -o volname=$projname,idmap=user,uid=501,gid=20" "$username"@"$projname":"$remotedir" "$dir" );
	echo "Mounting: "$username"@"$projname":"$remotedir" "$dir;
	${command[@]};
else
	echo "No such directory "$dir;
fi

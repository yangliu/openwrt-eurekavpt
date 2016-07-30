#!/bin/sh
FILE_DIR='/etc/eurekavpt'
VERSION_FILE="$FILE_DIR/version"
GFWLIST_FILE="$FILE_DIR/gfwlist.conf"
CHNROUTE_FILE="$FILE_DIR/chnroute.txt"
CDN_FILE="$FILE_DIR/cdn.txt"

ss_basic_gfwlist_update='1'
ss_basic_chnroute_update='1'
ss_basic_cdn_update='1'

LOGTIME=$(date "+%Y-%m-%d %H:%M:%S")

[ -f "$FILE_DIR" ] || mkdir -p "$FILE_DIR"

# version dectet
version_gfwlist1=$(cat $VERSION_FILE | sed -n 1p | sed 's/ /\n/g'| sed -n 1p)
version_chnroute1=$(cat $VERSION_FILE | sed -n 2p | sed 's/ /\n/g'| sed -n 1p)
version_cdn1=$(cat $VERSION_FILE | sed -n 4p | sed 's/ /\n/g'| sed -n 1p)

echo ========================================================================================================== 
echo $(date): Begin to update shadowsocks rules! please wait... 
wget --no-check-certificate --tries=1 --timeout=15 -qO - https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/maintain_files/version1 > /tmp/version1
online_content=$(cat /tmp/version1)
if [ -z "$online_content" ];then
	rm -rf /tmp/version1
	echo $(date): check version failed! 
	exit
fi


git_line1=$(cat /tmp/version1 | sed -n 1p)
git_line2=$(cat /tmp/version1 | sed -n 2p)
git_line4=$(cat /tmp/version1 | sed -n 4p)

version_gfwlist2=$(echo $git_line1 | sed 's/ /\n/g'| sed -n 1p)
version_chnroute2=$(echo $git_line2 | sed 's/ /\n/g'| sed -n 1p)
version_cdn2=$(echo $git_line4 | sed 's/ /\n/g'| sed -n 1p)

md5sum_gfwlist2=$(echo $git_line1 | sed 's/ /\n/g'| tail -n 2 | head -n 1)
md5sum_chnroute2=$(echo $git_line2 | sed 's/ /\n/g'| tail -n 2 | head -n 1)
md5sum_cdn2=$(echo $git_line4 | sed 's/ /\n/g'| tail -n 2 | head -n 1)


# update gfwlist
if [ "$ss_basic_gfwlist_update" == "1" ];then
	if [ ! -z "$version_gfwlist2" ];then
		if [ "$version_gfwlist1" != "$version_gfwlist2" ];then
			echo $(date): new version decteted, will update gfwlist 
			echo $(date): downloading gfwlist to tmp file 
			wget --no-check-certificate --tries=1 --timeout=15 -qO - https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/maintain_files/gfwlist.conf > /tmp/gfwlist.conf
			md5sum_gfwlist1=$(md5sum /tmp/gfwlist.conf | sed 's/ /\n/g'| sed -n 1p)
			if [ "$md5sum_gfwlist1"x = "$md5sum_gfwlist2"x ];then
				echo $(date): md5sum check succeed \for gfwlist, apply tmp file to the original file 
				mv /tmp/gfwlist.conf $GFWLIST_FILE
				sed -i "1s/.*/$git_line1/" $VERSION_FILE
				echo $(date): your gfwlist is up to date 
			else
				echo $(date): md5sum check failed \for gfwlist 
			fi
		else
			echo $(date): same version decteted,will not update gfwlist 
		fi
	else
		echo $(date): file down load failed \for gfwlist 
	fi
else
	echo $(date): gfwlist update not enabled 
fi


# update chnroute
if [ "$ss_basic_chnroute_update" == "1" ];then
	if [ ! -z "$version_chnroute2" ];then
		if [ "$version_chnroute1" != "$version_chnroute2" ];then
			echo $(date): new version decteted, will update chnroute 
			echo $(date): downloading chnroute to tmp file 
			wget --no-check-certificate --tries=1 --timeout=15 -qO - https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/maintain_files/chnroute.txt > /tmp/chnroute.txt
			md5sum_chnroute1=$(md5sum /tmp/chnroute.txt | sed 's/ /\n/g'| sed -n 1p)
			if [ "$md5sum_chnroute1"x = "$md5sum_chnroute2"x ];then
				echo $(date): md5sum check succeed \for chnroute, apply tmp file to the original file 
				mv /tmp/chnroute.txt $CHNROUTE_FILE
				sed -i "2s/.*/$git_line2/" $VERSION_FILE
				echo $(date): your chnroute is up to date 
			else
				echo $(date): md5sum check failed \for chnroute 
			fi
		else
			echo $(date): same version decteted,will not update chnroute 
		fi
	else
		echo $(date): file down load failed \for gfwlist 
	fi
else
	echo $(date): chnroute update not enabled 
fi


# update cdn file
if [ "$ss_basic_cdn_update" == "1" ];then
	if [ ! -z "$version_cdn2" ];then
		if [ "$version_cdn1" != "$version_cdn2" ];then
			echo $(date): new version decteted, will update cdn 
			echo $(date): downloading cdn list to tmp file 
			wget --no-check-certificate --tries=1 --timeout=15 -qO - https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/maintain_files/cdn.txt > /tmp/cdn.txt
			md5sum_cdn1=$(md5sum /tmp/cdn.txt | sed 's/ /\n/g'| sed -n 1p)
			if [ "$md5sum_cdn1"x = "$md5sum_cdn2"x ];then
				echo $(date): md5sum check succeed \for cdn, apply tmp file to the original file 
        mv /tmp/cdn.txt $CDN_FILE

				sed -i "4s/.*/$git_line4/" $VERSION_FILE
				echo $(date): your cdn is up to date 
			else
				echo $(date): md5sum check failed \for cdn 
			fi
		else
			echo $(date): same version decteted,will not update cdn 
		fi
	else
		echo $(date): file down load failed \for gfwlist 
	fi
else
	echo $(date): cdn update not enabled 
fi

rm -rf /tmp/gfwlist.conf1
rm -rf /tmp/chnroute.txt1
rm -rf /tmp/cdn.txt1
mv /tmp/version1 $VERSION_FILE
rm -rf /tmp/version1

echo $(date): Rules update complete! 
echo ========================================================================================================== 
exit

#!/bin/sh

# sizeof
# v0.3
# Get the size of a file in all relevant units

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Copyright (c) 2011 Mark Busby <mark .at. BusbyCreations .dot. com>  #
#                                                                     #
# This software is distributed under the terms of the zlib/libpng     #
# License.                                                            #
#                                                                     #
# This software is provided 'as-is', without any express or implied   #
# warranty. In no event will the authors be held liable for any       #
# damages arising from the use of this software.                      #
#                                                                     #
# Permission is granted to anyone to use this software for any        #
# purpose, including commercial applications, and to alter it and     #
# redistribute it freely, subject to the following restrictions:      #
#                                                                     #
#    1. The origin of this software must not be misrepresented; you   #
#    must not claim that you wrote the original software. If you use  #
#    this software in a product, an acknowledgment in the product     #
#    documentation would be appreciated but is not required.          #
#                                                                     #
#    2. Altered source versions must be plainly marked as such, and   #
#    must not be misrepresented as being the original software.       #
#                                                                     #
#    3. This notice may not be removed or altered from any source     #
#    distribution.                                                    #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# set bsd=true if running on bsd
BSD=false

printSize () {
	for suffix in b B kB MB GB TB PB; do
		if [ "$suffix" = "b" ]; then
			calculation='*8'
			precision='0'
			size=`echo "${1}$calculation" | bc`
		elif [ "$suffix" = B ]; then
			calculation=''
			precision='0'
			size=$1
		elif [ "$suffix" = kB ]; then
			calculation='/1024'
			precision='3'
			size=`echo "${1}*1000$calculation" | bc`
		elif [ "$suffix" = MB ]; then
			calculation='/1024/1024'
			precision='3'
			size=`echo "${1}*1000$calculation" | bc`
		elif [ "$suffix" = GB ]; then
			calculation='/1024/1024/1024'
			precision='3'
			size=`echo "${1}*1000$calculation" | bc`
		elif [ "$suffix" = TB ]; then
			calculation='/1024/1024/1024/1024'
			precision='3'
			size=`echo "${1}*1000$calculation" | bc`
		elif [ "$suffix" = PB ]; then
			calculation='/1024/1024/1024/1024/1024'
			precision='3'
			size=`echo "${1}*1000$calculation" | bc`
		fi
		
		greaterThanOneHundred=`echo "$size >= 100" | bc`
		if [ "$greaterThanOneHundred" = "1" ] || [ "$suffix" = "b" ] || [ "$suffix" = "B" ]; then
			output=`echo "scale=$precision; ${1}$calculation" | bc`
			echo "  $suffix: $output"
		else
			break
		fi
	done
}

usage () {
	echo "Usage: $0 [-a] file [file2 [...]]"
	exit
}

# this script requires "stat" and "bc" and "grep"
if [ "`which stat`" = "" ] || [ "`which bc`" = "" ] || [ "`which grep`" = "" ]; then
	usage
fi

if [ $# -lt 1 ]; then
	echo "Usage: $0 file [file2 [...]]"
fi

while [ "`echo $1 | grep -E ^[-].\{1,1\}`" ]; do
	case "${1#-}" in
		a )
			# print size of all files (default is to print total, only)
			echo "Showing sizes of all files"
			printAll=1
			;;
		* )
			# unknown option
			usage
	esac
	shift
done

for file in "$@"; do
	if [ -d "$file" ]; then
		continue;
	fi
	
	if [ "$BSD" = "true" ]; then
		# bsd
		sizeorig=`stat -f %z $file`
	else
		# linux
		sizeorig=`stat --printf %s $file`
	fi
	
	total=$((total+sizeorig))
	
	if [ "$printAll" = 1 ]; then
		echo "size of $file:"
		printSize $sizeorig
	fi
done

if [ $# -gt 1 ]; then
	echo "Total size:"
	printSize $total
fi

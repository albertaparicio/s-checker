#!/bin/bash

# v2.0
#	
# S Checker - Multi-algorithm checksum checker and ISO against disk comparator
#
# ©Copyright (C) 2015 Albert Aparicio

get_help(){
echo "schecker (S Checker) v2.0 ©Copyright (C) 2015 Albert Aparicio

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

S Checker source code available from albert.aparicio.isarn@gmail.com.
Use PGP encryption on the emails, with public signature 0xE9920BEE.

-------------------------------------------------------------------
This program has two modes:
 · Compare disk against ISO image
 · Checksum checking

Supported algorithms: MD5, SHA1, SHA256, SHA512

Syntax: schecker [mode|algorithm] [-f filename] [-c checksum]

Options:

 -i,  --iso     compare disk against ISO image

 -m,  --md5	use MD5 algorithm
 -s1, --sha1	use SHA1 algorithm
 -s2, --sha256	use SHA256 algorithm
 -s5, --sha512	use SHA512 algorithm

 -h,  --help    get help

Commands:

 -f		specify filename
 -c		specify alleged file checksum
 -d,  --device	specify disk device (/dev/DISK)

Examples:

 -m -f [file] -c [checksum]	check MD5 hash
 --sha1 -f [file] -c [checksum]	check SHA1 hash
 -i -f image.iso -d /dev/sr0    compare disk in /dev/sr0 against image.iso image"
 
}

usage()
{
    echo "schecker (S Checker) v2.0 ©Copyright (C) 2015 Albert Aparicio

Usage: schecker [[[-m]|[-s1]|[-s2]|[-s5]|[-i]] [-f filename] [[-c checksum]|[-d device]]|[-h]]
"
}

md5_sum(){
   if [ -n "$( md5sum $filename | grep $checksum )" ]; then
     echo "<---Checksum Match--->"
     exit 0
   else
     echo "!!--Checksum Mismatch--!!"
     exit 0
   fi
}

sha1_sum(){
   if [ -n "$( sha1sum $filename | grep $checksum )" ]; then
     echo "<---Checksum Match--->"
     exit 0
   else
     echo "!!--Checksum Mismatch--!!"
     exit 0
   fi
}
sha256_sum(){
   if [ -n "$( sha256sum $filename | grep $checksum )" ]; then
     echo "<---Checksum Match--->"
     exit 0
   else
     echo "!!--Checksum Mismatch--!!"
     exit 0
   fi
}
sha512_sum(){
   if [ -n "$( sha512sum $filename | grep $checksum )" ]; then
     echo "<---Checksum Match--->"
     exit 0
   else
     echo "!!--Checksum Mismatch--!!"
     exit 0
   fi
}
iso_image(){
   if [ -z "$( cmp $device $filename  )" ]; then
     echo "<---Disk Matched ISO--->"
     exit 0
   else
     echo "!!--Disk Not Matched--!!"
     exit 0
   fi
}
   

show_data(){
	clear
	# ASCII Art -> ANSI Shadow (http://patorjk.com/software/taag/)
	echo "███████╗     ██████╗██╗  ██╗███████╗ ██████╗██╗  ██╗███████╗██████╗ 
██╔════╝    ██╔════╝██║  ██║██╔════╝██╔════╝██║ ██╔╝██╔════╝██╔══██╗
███████╗    ██║     ███████║█████╗  ██║     █████╔╝ █████╗  ██████╔╝
╚════██║    ██║     ██╔══██║██╔══╝  ██║     ██╔═██╗ ██╔══╝  ██╔══██╗
███████║    ╚██████╗██║  ██║███████╗╚██████╗██║  ██╗███████╗██║  ██║
╚══════╝     ╚═════╝╚═╝  ╚═╝╚══════╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
                                                                    "
	echo "S Checker v2.0 ©Copyright (C) 2015 Albert Aparicio"
}

sum_data(){
	echo "
Mode: Checksum checking

Algorithm: $algorithm
File: $filename
Checksum: $checksum

Computing checksum...
"
}

iso_data(){
	echo "
Mode: Compare disk against ISO image

ISO File: $filename
Device: $device

Comparing...
"
}

mode=
checksum=
filename=
device=

# Display usage if no arguments passed
[ $# -eq 0 ] && { usage; exit 1; }

while [ "$1" != "" ]; do
    case $1 in
        -f | --file )           shift
                                filename=$1
                                ;;
        -i | --iso )    	mode=ISO
                                ;;
        -m | --md5 )    	mode=MD5
                                ;;
        -s1 | --sha1 )    	mode=SHA1
                                ;;
        -s2 | --sha256 )    	mode=SHA256
                                ;;
        -s5 | --sha512 )    	mode=SHA512
                                ;;
        -c | --checksum )    	shift
				checksum=$1
                                ;;
        -d | --device )    	shift
				device=$1
                                ;;
        -h | --help )           get_help
                                exit 0
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

echo ""

case $mode in

	ISO ) show_data;iso_data;iso_image;;

	MD5 ) show_data;sum_data;md5_sum;;

	SHA1 ) show_data;sum_data;sha1_sum;;

	SHA256 ) show_data;sum_data;sha256_sum;;

	SHA512 ) show_data;sum_data;sha512_sum;;

esac

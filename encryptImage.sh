#!/bin/bash

echo "This pgm carry out Encrypting/Decrypting an image using AES."

while :
do
echo "Please select a mode" 
echo "------------------------------------------------------------"
echo "1. Encrypt image file"
echo "2. Decrypt image file"
echo "------------------------------------------------------------"	
read mode
echo "------------------------------------------------------------"
case $mode in 
	1)
		echo "Encrypt image file."
		echo "Select a image file."
		echo "------------------------------------------------------------"
		echo "File lists extension (.jpg, .png, .jpeg)"
		# current directory에서 image file list를 보여준다.
		for f in $(ls -1 | grep -e '.*\.jpg' -e '.*\.png' -e '.*\.jpeg' ) 
   		do
      			echo "\"$f\""
    		done
		echo "------------------------------------------------------------"
		echo "Enter the image full name (include extension)"
		read image_name
		# image_name string에서 . 기준으로 제일 첫번째 element return
		name=`echo $image_name | cut -d '.' -f1`
		echo $name

		echo "------------------------------------------------------------"
		# Check file exist
		if [ `find . -name $image_name` ]
		then
			# First convert image to base64
			echo "Convert image to base64."
			base64 $image_name > $name.b64
			echo -ne '#####                     (33%)\r'
			sleep 0.7
			echo -ne '#############             (66%)\r'
			sleep 0.7
			echo -ne '#######################   (100%)\r'
			echo -ne '\n'

			# Second ecrypt image by aes
			echo "Encrypt base64 image using AES."
			openssl aes-256-cbc -a -salt -in $name.b64 -out $name.enc
			echo -ne '#####                     (33%)\r'
			sleep 0.7
			echo -ne '#############             (66%)\r'
			sleep 0.7
			echo -ne '#######################   (100%)\r'
			echo -ne '\n'

			# convert image(base64) -> don't need anymore
			rm -rf $name.b64
			echo -e "Complete Encrypt image -> named $name.enc \n\n"

		else
			echo "File does not exist."
		fi

		;;
	2)
		echo "Decrypt image file"
		echo "Select a image file."
		echo "------------------------------------------------------------"
		echo "File lists extension (.enc)"
		# current direcoty에서 .enc 파일들의 list를 보여준다.
		for f in $(ls -1 | grep -e '.*\.enc') 
   		do
      			echo "\"$f\""
    		done
		echo "------------------------------------------------------------"
		echo "Enter the image full name (include extension)"
		read image_name
		name=`echo $image_name | cut -d '.' -f1`
		echo $name

		echo "------------------------------------------------------------"
		if [ `find . -name $image_name` ]
		then
			echo "Decrypting image"
			# Decrypt image using openssl
			if [ `openssl aes-256-cbc -d -a -in $image_name -out $name.dec` ] 
			then
				# if password not verity
				echo "Password does not match"
				exit 1
			else
				# decode base64 image -> original image
				base64 -d $name.dec > $name.jpg
				echo -ne '#####                     (33%)\r'
				sleep 0.7
				echo -ne '#############             (66%)\r'
				sleep 0.7
				echo -ne '#######################   (100%)\r'
				echo -ne '\n'
				# decrypt file -> don't need anymore
				rm -rf $name.dec
				echo -e "Complete Decrypt image -> named $name.jpg \n\n"
			fi
		else
			echo "File does not exist."
		fi

		;;
	*)
		echo "Sorry, We don't supported."
		;;
esac
done

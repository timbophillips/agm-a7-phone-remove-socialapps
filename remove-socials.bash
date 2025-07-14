#!/bin/bash

RARFILENAME="M7_tool_and_ upgrade operation_20210616_Europe"
ZIPFILENAME="PQ1181CWE25A.AGM.O1.QV.KFS39SST.210616.V3.10"
SOCIALAPPS="Chrome Facebook Skype Tiktok Whatsapp Zello"

#check if unrar is installed
if command -v unrar >/dev/null 2>&1; then
  echo "unrar already installed."
else
  echo "unrar needs to be installed"
  sudo apt install unrar
fi

#check if android-sdk-libsparse-utils is installed
if command -v simg2img >/dev/null 2>&1; then
  echo "android-sdk-libsparse-utils already installed."
else
  echo "android-sdk-libsparse-utils needs to be installed"
  sudo apt install android-sdk-libsparse-utils
fi

mkdir files
mkdir "./files/$ZIPFILENAME"
mkdir "./files/system.img.mount"
mkdir "./files/SP_Flash_Tool"

unrar x "./$RARFILENAME" ./files/

unzip "./files/$RARFILENAME/$ZIPFILENAME.zip" -d "./files/$ZIPFILENAME/"

simg2img "./files/$ZIPFILENAME/system.img" "./files/system.img.raw"

sudo mount -t ext4 -o loop "./files/system.img.raw" "./files/system.img.mount"

cd "./files/system.img.mount/app/"

sudo rm -R $SOCIALAPPS

cd -

sudo umount ./files/system.img.mount

rm "./files/$ZIPFILENAME/system.img"

img2simg "./files/system.img.raw" "./files/$ZIPFILENAME/system.img"

<<<<<<< HEAD
sed -i 's/CHECKSUM_SWITCH=1/CHECKSUM_SWITCH=0/g' "./files/$ZIPFILENAME/Checksum.ini"

unzip ./SP_Flash_Tool_v5.2228_Linux -d "./files/"

cd "./files/SP_Flash_Tool_v5.2228_Linux"
=======
unzip ./SP_Flash_Tool_v5.2228_Linux -d "./files/SP_Flash_Tool"

cd "./files/SP_Flash_Tool"
>>>>>>> 2fced90 (tidier)

sh ./flash_tool.sh 





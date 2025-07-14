# This script removes social media applications from the AGM M7 smartphone firmware.
# It requires the unrar and android-sdk-libsparse-utils packages to be installed.
# The script extracts the firmware, mounts the system image, removes specified social apps,
# and prepares the modified firmware for flashing back to the device.

# Requirements:
# - unrar: for extracting the firmware archive.
# - android-sdk-libsparse-utils: for converting sparse images to raw images.
# - SP Flash Tool: for flashing the modified firmware back to the device.
# - AGM M7 smartphone: the device for which the firmware is being modified.
# - AGM M7 firmware archive: the source firmware file to be modified.
# - SP Flash Tool Linux version: for flashing the modified firmware.
# - Bash shell: to run this script.

# Usage:
# 1. Ensure you have the AGM M7 firmware archive and SP Flash Tool Linux version
#    in the same directory as this script.
# 2. Run the script: `bash remove-socials.bash`

# Sources for the tools and firmware:
# - AGM M7 firmware: https://www.agmmobile.com/pages/software-download
# - SP Flash Tool: https://spflashtools.com/linux/sp-flash-tool-v5-2228-for-linux

# Adjust the following variables as needed:
# RARFILENAME: Name of the firmware archive file (should be in the same directory as this script).
# ZIPFILENAME: Name of the extracted firmware zip file (that is witihin the RAR file).
# SOCIALAPPS: List of social media applications to be removed from the firmware.
# Example: "Chrome Facebook Skype Tiktok Whatsapp Zello"

#!/bin/bash
set -e          # Exit on error
set -u          # Treat unset variables as an error
set -o pipefail # Fail on any command in a pipeline that fails

# Define variables
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

# Check if SP Flash Tool is already downloaded
if [ ! -f "./SP_Flash_Tool_v5.2228_Linux.zip" ]; then
  echo "SP Flash Tool not found, you will need to download it."
  echo "Download from: https://spflashtools.com/linux/sp-flash-tool-v5-2228-for-linux"
  echo "After downloading, place the SP_Flash_Tool_v5.2228_Linux.zip file in the current directory."
  exit 1
else
  echo "SP Flash Tool already downloaded."
fi

# Create necessary directories
if [ ! -d "./files" ]; then
  echo "Creating files directory..."
  mkdir files
else
  echo "Files directory already exists."
fi

# Create directories for extracted files and system image
if [ ! -d "./files/$ZIPFILENAME" ]; then
  echo "Creating directory for extracted firmware..."
  mkdir "./files/$ZIPFILENAME"
else
  echo "Directory for extracted firmware already exists."
fi
if [ ! -d "./files/system.img.mount" ]; then
  echo "Creating directory for mounted system image..."
  mkdir "./files/system.img.mount"
else
  echo "Directory for mounted system image already exists."
fi

# Extract the firmware archive
if [ ! -f "./$RARFILENAME.rar" ]; then
  echo "Firmware archive not found, please place it in the current directory."
  exit 1
else
  echo "Extracting firmware archive..."
  unrar x "./$RARFILENAME" "./files/"
fi

# Check if the firmware zip file exists
if [ ! -f "./files/$RARFILENAME/$ZIPFILENAME.zip" ]; then
  echo "Firmware zip file not found, please check the RAR file contents."
  exit 1
else
  echo "Extracting firmware zip file..."
  unzip "./files/$RARFILENAME/$ZIPFILENAME.zip" -d "./files/$ZIPFILENAME/"
fi

# Check if the system image exists
if [ ! -f "./files/$ZIPFILENAME/system.img" ]; then
  echo "System image not found, please check the firmware zip file."
  exit 1
else
  echo "System image found, proceeding with modification..."
  simg2img "./files/$ZIPFILENAME/system.img" "./files/system.img.raw"
fi
# Mount the system image
if mountpoint -q "./files/system.img.mount"; then
  echo "System image is already mounted."
else
  echo "Mounting system image..."
  sudo mount -t ext4 -o loop "./files/system.img.raw" "./files/system.img.mount"
fi

# Remove specified social media applications
cd "./files/system.img.mount/app/"
sudo rm -R $SOCIALAPPS
cd -

# Unmount the system image
if mountpoint -q "./files/system.img.mount"; then
  echo "Unmounting image..."
  sudo umount -f "./files/system.img.mount"
else
  echo "System image is not mounted."
fi
# Convert the modified system image back to sparse format
if [ ! -f "./files/system.img.raw" ]; then
  echo "Raw system image not found, cannot convert to sparse format."
  exit 1
else
  echo "Converting raw system image to sparse format..."
  if [ -f "./files/$ZIPFILENAME/system.img" ]; then
    rm "./files/$ZIPFILENAME/system.img"
  fi
  img2simg "./files/system.img.raw" "./files/$ZIPFILENAME/system.img"
fi

# Modify the Checksum.ini file to disable checksum switch
if [ ! -f "./files/$ZIPFILENAME/Checksum.ini" ]; then
  echo "Checksum.ini file not found, cannot modify checksum switch."
  exit 1
else
  echo "Modifying Checksum.ini to disable checksum switch..."
  sed -i 's/CHECKSUM_SWITCH=1/CHECKSUM_SWITCH=0/g' "./files/$ZIPFILENAME/Checksum.ini"
fi

# Unzip the SP Flash Tool
if [ ! -f "./SP_Flash_Tool_v5.2228_Linux.zip" ]; then
  echo "SP Flash Tool zip file not found, please check the download."
  exit 1
else
  echo "SP Flash Tool zip file found, proceeding with unzipping..."
  echo "Unzipping SP Flash Tool..."
  unzip ./SP_Flash_Tool_v5.2228_Linux -d "./files/"
fi

# Run the SP Flash Tool
if [ ! -d "./files/SP_Flash_Tool_v5.2228_Linux" ]; then
  echo "SP Flash Tool directory not found, please check the unzipping process."
  exit 1
else
  echo "SP Flash Tool directory found, proceeding to run the tool..."
  cd "./files/SP_Flash_Tool_v5.2228_Linux"
  sh ./flash_tool.sh
fi

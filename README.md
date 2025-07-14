     This script removes social media applications from the AGM M7 smartphone firmware.
     It requires the unrar and android-sdk-libsparse-utils packages to be installed.
     The script extracts the firmware, mounts the system image, removes specified social apps,
     and prepares the modified firmware for flashing back to the device.
    
     Requirements:
     - unrar: for extracting the firmware archive.
     - android-sdk-libsparse-utils: for converting sparse images to raw images.
     - SP Flash Tool: for flashing the modified firmware back to the device.
     - AGM M7 smartphone: the device for which the firmware is being modified.
     - AGM M7 firmware archive: the source firmware file to be modified.
     - SP Flash Tool Linux version: for flashing the modified firmware.
     - Bash shell: to run this script.
    
     Usage:
     1. Ensure you have the AGM M7 firmware archive and SP Flash Tool Linux version
        in the same directory as this script.
     2. Run the script: `bash remove-socials.bash`
    
     Sources for the tools and firmware:
     - AGM M7 firmware: https://www.agmmobile.com/pages/software-download
     - SP Flash Tool: https://spflashtools.com/linux/sp-flash-tool-v5-2228-for-linux
    
     Adjust the following variables as needed:
     RARFILENAME: Name of the firmware archive file (should be in the same directory as this script).
     ZIPFILENAME: Name of the extracted firmware zip file (that is witihin the RAR file).
     SOCIALAPPS: List of social media applications to be removed from the firmware.
     Example: "Chrome Facebook Skype Tiktok Whatsapp Zello"

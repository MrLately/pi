#!/bin/bash

# Configuration variables
MOUNT_POINT="/mnt/nas"
SHARE_NAME="nas"
USER_NAME="pi" # Default user
GROUP_NAME="pi" # Default group

# Ensure the script is run as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Update and Upgrade Raspberry Pi OS
echo "Updating and upgrading Raspberry Pi OS..."
apt-get update && apt-get upgrade -y

# Detect and list all connected external drives with their names, sizes, and models
echo "Detecting connected external drives..."
lsblk -o NAME,SIZE,MODEL -dp | grep -v "boot\|root" 
echo "Please enter the device name to use (e.g., /dev/sda):"
read -r SSD_DEVICE

if [ -z "$SSD_DEVICE" ]; then
    echo "No drive specified. Exiting."
    exit 1
fi

echo "Drive selected: $SSD_DEVICE"

# WARNING: The next commands will format the drive.
echo "WARNING: This will format $SSD_DEVICE as Ext4, erasing all data. Proceed? (y/n)"
read -r proceed
if [ "$proceed" != "y" ]; then
    echo "Operation cancelled."
    exit 1
fi

echo "Formatting the SSD to Ext4..."
mkfs.ext4 $SSD_DEVICE

# Create mount point and update /etc/fstab
echo "Creating mount point at $MOUNT_POINT"
mkdir -p $MOUNT_POINT
UUID=$(blkid -o value -s UUID $SSD_DEVICE)
echo "UUID=$UUID $MOUNT_POINT ext4 defaults,auto,users,rw,nofail 0 0" >> /etc/fstab

# Mount the SSD
echo "Mounting the SSD..."
mount -a

# Install Samba for file sharing
echo "Installing Samba..."
apt-get install samba samba-common-bin -y

# Configure Samba Share named "ninnie"
echo "Configuring Samba Share named $SHARE_NAME for $MOUNT_POINT..."
cat >> /etc/samba/smb.conf <<EOT

[$SHARE_NAME]
path = $MOUNT_POINT
writeable=Yes
create mask=0777
directory mask=0777
public=yes
browsable=yes
guest ok=yes
force user=$USER_NAME
force group=$GROUP_NAME
EOT

# Restart Samba to apply the configuration
echo "Restarting Samba..."
systemctl restart smbd

echo "NAS setup and Samba configuration completed."

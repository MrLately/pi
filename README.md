# Raspberry Pi SAMBA NAS Setup Script

This script automates the setup process for creating a Network-Attached Storage (NAS) server using a Raspberry Pi.
It installs necessary packages, mounts an external drive for storage (which you select), configures a Samba share for file sharing.

## Prerequisites

- Raspberry Pi running Raspberry Pi OS (I went with legacy 64 bit lite)
- External storage device (SSD or hard drive)

## Configuration

Before running the script, make sure to adjust the configuration variables in the script
according to your preferences (can leave default):

- `MOUNT_POINT`: The directory where the external drive will be mounted.
- `SHARE_NAME`: The name of the Samba share.
- `USER_NAME`: Pi username. pi by default.
- `GROUP_NAME`: Pi groupname. pi by default.

## Usage

# Clone this repository to your Raspberry Pi
git clone https://github.com/MrLately/pi_nas.git

# Navigate to the repository directory
cd pi_nas

# Make the script executable
chmod +x pi_nas.sh

# Run the script with root privileges
sudo ./pi_nas.sh

### Further Configuration

I ran these after setup because they are what i wanted, you may want different:

mkdir -p /mnt/nas/Movies

mkdir -p /mnt/nas/Series

mkdir -p /mnt/nas/Pictures

mkdir -p /mnt/nas/Documents

To edit the SAMBA config further run:

sudo nano /etc/samba/smb.conf

#### Accessing the Samba Share

Once the setup is complete, you can access the Samba share from any device on your network. Use the following steps:

1. Open File Explorer (Windows) or Finder (macOS).
2. Enter the following address in the address bar:
   \\RASPBERRY_PI_IP\SHARE_NAME
Replace `RASPBERRY_PI_IP` with the IP address of your Raspberry Pi and `SHARE_NAME` with the configured share name.
<img width="321" alt="gh" src="https://github.com/MrLately/nas_plex/assets/94589563/483a8e53-77b5-4900-86c6-9aa2a09f86fb">
<img width="674" alt="gh" src="https://github.com/MrLately/nas_plex/assets/94589563/1866ced2-ed14-4b6a-abd9-422577fe0f0e">

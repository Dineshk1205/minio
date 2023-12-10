set -e
disk=$(whiptail --inputbox "Hellow,Please Enter the Name of the raw disk🛢for minio (ex:- /dev/sdb /dev/sdc " --title "🛢 Disk Name 🛢" 10 70 3>&1 1>&2 2>&3 )
user=$(whiptail --inputbox  "Please Enter MINIO Root UserName👤" --title "👤 User 👤" 10 45 3>&1 1>&2 2>&3 )
pass=$(whiptail --passwordbox  "Please Enter MINIO Root Password🔑" --title "🔐 Password 🔐" 10 45 3>&1 1>&2 2>&3 )
sudo mkdir /minio
if [ -f /etc/redhat-release ]; then
   sudo mkfs.xfs -f $disk
   echo "$disk /minio xfs defaults,noatime,nofail 0 0" >> /etc/fstab
   sudo systemctl daemon-reload
   mount -a
   sudo wget https://dl.min.io/server/minio/release/linux-amd64/archive/minio-20231207041600.0.0-1.x86_64.rpm -O minio.rpm
   sudo dnf install minio.rpm -y 
fi
if [ -f /etc/lsb-release ]; then
  sudo mkfs.ext4 $disk
  echo "$disk /minio ext4 defaults,noatime,nofail 0 0" >> /etc/fstab
  sudo systemctl daemon-reload
  mount -a
  sudo wget https://dl.min.io/server/minio/release/linux-amd64/archive/minio_20231207041600.0.0_amd64.deb -O minio.deb
  sudo dpkg -i minio.deb
fi
sudo groupadd -r minio-user
sudo useradd -M -r -g minio-user minio-user
sudo chown minio-user:minio-user /minio/
echo "MINIO_ROOT_USER= "$user"" >> /etc/default/minio
echo "MINIO_ROOT_PASSWORD= "$pass"" >> /etc/default/minio
echo "MINIO_VOLUMES= \"/minio\"" >> /etc/default/minio
sudo systemctl start minio.service
sudo systemctl enable minio.service
whiptail --msgbox "ℹ️ USE the URL 🔗➡'http://IP or FQDN:9000' to acess the MINIO Dashboard." --title "🚀 MINIO Deployment Successfully Completed ☑️ 👏" 10 150 

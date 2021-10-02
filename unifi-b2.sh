# Read access to UniFi backup directory
sudo chmod -R 705 /var/lib/unifi/backup/
 

# https://www.linkedin.com/in/francesco-fedele-0702b614b/
# https://www.backblaze.com/b2/cloud-storage.html
cd /tmp
sudo apt-get install unzip -y
curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip
unzip rclone-current-linux-amd64.zip
cd rclone-*-linux-amd64
 
# Install rclone
# Binary
sudo cp rclone /usr/sbin/
sudo chown root:root /usr/sbin/rclone
sudo chmod 755 /usr/sbin/rclone
# Manpage
sudo mkdir -p /usr/local/share/man/man1
sudo cp rclone.1 /usr/local/share/man/man1/
sudo mandb 
 
# Configure rclone for use with Backblaze B2
# Use your bucket settings
rclone config
n # New Config
	B2_UNIFI.CONTROLLER.NAME # Select a Name
	3 # 3 for Backblaze B2
	884456abcdef # Provide Accound ID
	001b6b8e684f123456abcdef123456abcdef123abc # Provide Application Key
    # Blank Endpoint
	y # Save
	q
 
# Automate backups with rclone
touch /usr/local/bin/unifi_b2_backup.sh
sudo echo -e '#!/bin/bash\ncd /tmp\n# Backup /var/lib/unifi/backup\nTIMESTMP=$(date +'%Y%m%d_%H%M%S')\ntar -zcvf backup.$TIMESTMP.tar.gz /var/lib/unifi/backup\n/usr/sbin/rclone copy /tmp/backup.$TIMESTMP.tar.gz B2_UNIFI.CONTROLLER.NAME:BUCKETNAME-unifi\nrm backup.$TIMESTMP.tar.gz\n\n# Backup /var/lib/unifi/sites\nTIMESTMP=$(date +'%Y%m%d_%H%M%S')\ntar -zcvf sites.$TIMESTMP.tar.gz /var/lib/unifi/sites\n/usr/sbin/rclone copy /tmp/sites.$TIMESTMP.tar.gz B2_UNIFI.CONTROLLER.NAME:BUCKETNAME-unifi\nrm sites.$TIMESTMP.tar.gz\n\n# Remote Cleanup\n# Only run Cleanup if there are data present in bucket newer than 6 weeks == previous backups successful\nif [[ $(/usr/sbin/rclone ls B2_UNIFI.CONTROLLER.NAME:BUCKETNAME-unifi --max-age 6w) ]]; then\n# Delete everything older than 6 weeks\n/usr/sbin/rclone delete B2_UNIFI.CONTROLLER.NAME:BUCKETNAME-unifi --min-age 6w\n/usr/sbin/rclone cleanup B2_UNIFI.CONTROLLER.NAME:BUCKETNAME-unifi --min-age 8w\nfi' | sudo tee -a /usr/local/bin/unifi_b2_backup.sh
sudo chmod +x /usr/local/bin/unifi_b2_backup.sh
# Schedule Cron Job to run unifi_b2_backup.sh every Sunday, After UniFi Controller Automated Backups
sudo crontab -l | { cat; echo "45 21 * * 0 /usr/local/bin/unifi_b2_backup.sh"; } | crontab -
#AHAHAHAHAH

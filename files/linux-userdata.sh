#!/bin/sh

# Create a log that ec2-user and root can write to
LOG=/userdata.log
sudo touch $LOG
sudo chown ec2-user $LOG
sudo chmod 664 $LOG

sudo echo -e "Installing Apache...\n====================" >> ~/userdata.log
sudo yum install httpd -y >> ~/userdata.log
sudo echo -e "\n\n\nEnabling Apache service on reboots...\n=====================================" >> ~/userdata.log
sudo systemctl enable httpd >> ~/userdata.log
sudo echo -e "\n\n\nStarting Apache now...\n======================" >> ~/userdata.log
sudo systemctl start httpd >> ~/userdata.log

# Install Nginx
sudo amazon-linux-extras install nginx1 >> $LOG

# Download the static HTML file from the S3 bucket >> $LOG
sudo aws s3 cp s3://acad-terraform/index.html /usr/share/nginx/html/index.html >> $LOG

# Start nginx
systemctl enable nginx
systemctl start nginx

# Check if ebs volumes need to be formatted (Userdata should only run on first boot... but lets not take chances with data!)
for disk in `lsblk|egrep -v "NAME|xvda" | awk '{print $1}'` ; do
   echo "Checking if $disk is formatted already" >> $LOG
   formatcheck=`sudo file -s /dev/xvdf | awk '{print $NF}'`
   if [ $formatcheck == data ] ; then
      echo "$disk is already formatted... not formatting." >> $LOG
   else
      echo "$disk is unformatted...formatting with XFS..." >> $LOG
      sudo mkfs.xfs /dev/${disk}
   fi
done

## Update fstab, but back it up first
sudo cp -p /etc/fstab /etc/fstab.`date '+%d-%m-%Y'`

# Note - we added /dev/sdb and /dev/sdc in the AWS consle, that translates to /dev/xvdb & /dev/xvdc in Linux"
# If you're adding more volumes remember to add the relevent lines to the list below:
sudo sh -c "echo '/dev/xvdb     /data     xfs     defaults      0      2' >> /etc/fstab"
sudo sh -c "echo '/dev/xvdc     /logs     xfs     defaults      0      2' >> /etc/fstab"

# Create the mounpoints if they don't exist. In this example we're mounting on /data & /logs
for mount in logs data ; do
   test -d $mount || sudo mkdir $mount
done


# Now mount the volumes
sudo mount -a
#!/bin/bash
# must be run as root
# must be run with image "CentOS-8.X.-.iso" with minimal install
# must be prepared /etc/selinux/config > SELINUX=disabled > reboot
# must be confirmed script sequence before running

# required
DNS=""						# set your dns server
NTP=""						# set your ntp server

# optional
SWAP_OFF=true				# set swap fs off
REPO_PATH=""				# set your repository
REPO_UPGRADE=true			# trigger upgrade task
SSL_PUB_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJs32FbeAfkYaVvu9CfyRehVRRUUU3fFZ+qKv5yRxWrjwtJ58q+ApzvocLBF5Y65kTSPfshomBzn9aBZhuDV9Cm+7ivOd6AAln1bVt48GpWImyG5kumzgBY8reI2qYzoNN6FPN/EMdEeNqFLOJ3FLMx6eTKfBSq+R4R2livNLnvj0QaKexHgT2rkxSpvmilXy9QRwKTmdkfGOawKNwAdU9FIALiTtlGKz8d5+QkCkvytDdv069Xml/oO9/gLDHbTwCerIKzOaIeaigSwEFDaL0qGMv+9htphhnm+IkNAkGVcFlT5nC5X8Oz4CVO+f9tl3zlR74WBHngiBTzukSGCpF2tmI9ZZxTzFbTcGXvBDVH0A5nZkZV4u42ab5HsHfYR+uE19mTZ38Salz/jqqdM/Qo7BR/Oc0Kx2Q5UNwe5gcVDZO3Q+nm7fAlnqPbQOXGk37bW4M8pZvDaoruC64y/q2Mdid0iUu0Ux488LqPNgBEYJ0Xsm4nTnPvZpayRxSAyU= root@VMW-Ansible-Host-000174"				# set your master public ssh key
TIME_ZONE="Asia/Seoul"		# set your timezone

# remove non-cloudic packages
## swap system off			# check stable way
if [ $SWAP_OFF == true ]; then
swapoff -a
rm -rf /swap.img
sed -i '/swap/d' /etc/fstab
fi

## remove package from yum
systemctl disable vmtoolsd
systemctl stop vmtoolsd
yum remove -y open-vm-tools


# upgrade && install basic packages
yum update
yum install epel-release




mkdir -p /root/.ssh
if [ -n "$SSL_PUB_KEY" ]; then
	echo "$SSL_PUB_KEY" >> /root/.ssh/authorized_keys
	chmod 600 /root/.ssh/authorized_keys
fi
systemctl restart sshd







# install required packages
## vmware tools
echo "check vmware tools disconnection in vcenter"
echo "and execute installing vmware tools in guest operation menu"
echo -n "press enter to next: "; read _KEY
mount /dev/cdrom /mnt
cp /mnt/VMwareTools-* /tmp/vmtools.tar.gz
cd /tmp && tar -xzvf vmtools.tar.gz
/tmp/vmware-tools-distrib/vmware-install.pl
cd ~


# vra-init
## from base64 encoded; check "https://github.com/vmware-cmbu-seak/aria-automation/tree/main/images"
VRA_INIT_SVC="W1VuaXRdCkRlc2NyaXB0aW9uPXZSZWFsaXplIEF1dG9tYXRpb24gSW5pdCBTZXJ2aWNlCkFmdGVyPXZtd2FyZS10b29scy5zZXJ2aWNlCgpbU2VydmljZV0KVHlwZT1vbmVzaG90CkV4ZWNTdGFydD0vdXNyL2Jpbi92cmEtaW5pdApSZW1haW5BZnRlckV4aXQ9eWVzClRpbWVvdXRTZWM9MApLaWxsTW9kZT1wcm9jZXNzClRhc2tzTWF4PWluZmluaXR5ClN0YW5kYXJkT3V0cHV0PWpvdXJuYWwrY29uc29sZQoKW0luc3RhbGxdCldhbnRlZEJ5PW11bHRpLXVzZXIudGFyZ2V0"
VRA_INIT="IyEvYmluL2Jhc2gKQ0hFQ0tfTkVUV09SS19USUNLPTEKZnVuY3Rpb24gX2NoZWNrX25ldHdvcmsgewogICAgbG9jYWwgREVWX05BTUU9YGlwIGxpbmsgfCBncmVwICJeMjoiIHwgYXdrICd7cHJpbnQgJDJ9JyB8IHNlZCAtZSAncy86Ly9nJ2AKICAgIGlmIFsgLXogIiRERVZfTkFNRSIgXTsgdGhlbiByZXR1cm4gMTsgZmkKICAgIGlmIFsgLXogImBpcCBhZGRyIHNob3cgZGV2ICRERVZfTkFNRSB8IGdyZXAgImluZXQgIiB8IGF3ayAne3ByaW50ICQyfScgfCBzZWQgLWUgJ3MvXC8uXCsvL2cnYCIgXTsgdGhlbiByZXR1cm4gMTsgZmkKICAgIHJldHVybiAwCn0KZnVuY3Rpb24gY2hlY2tfbmV0d29yayB7CiAgICB3aGlsZSB0cnVlOyBkbwogICAgICAgIF9jaGVja19uZXR3b3JrCiAgICAgICAgaWYgWyAkPyA9PSAgMCBdOyB0aGVuIGJyZWFrOyBmaQogICAgICAgIHNsZWVwICRDSEVDS19ORVRXT1JLX1RJQ0sKICAgIGRvbmUKfQpmdW5jdGlvbiBfc3RhcnRfY2xvdWRfaW5pdCB7CiAgICAvdXNyL2Jpbi9jbG91ZC1pbml0IGluaXQgLS1sb2NhbAogICAgL3Vzci9iaW4vY2xvdWQtaW5pdCBpbml0CiAgICAvdXNyL2Jpbi9jbG91ZC1pbml0IG1vZHVsZXMgLS1tb2RlPWNvbmZpZwogICAgL3Vzci9iaW4vY2xvdWQtaW5pdCBtb2R1bGVzIC0tbW9kZT1maW5hbAp9CmZ1bmN0aW9uIHN0YXJ0X2Nsb3VkX2luaXQgewogICAgY2hlY2tfbmV0d29yawogICAgX3N0YXJ0X2Nsb3VkX2luaXQgMj4mMSA+L3Zhci9sb2cvY2xvdWQtaW5pdC5sb2cgJgp9CmlmIFsgLWYgL2V0Yy92cmEtcmVhZHkgXTsgdGhlbgogICAgaWYgWyAiT0siICE9ICIkKGNhdCAvZXRjL3ZyYS1yZWFkeSkiIF07IHRoZW4gc3RhcnRfY2xvdWRfaW5pdDsgZmkKICAgIGVjaG8gIk9LIiA+IC9ldGMvdnJhLXJlYWR5CmVsc2UKICAgIHRvdWNoIC9ldGMvdnJhLXJlYWR5CmZp"
VRA_READY="IyEvYmluL2Jhc2gKIyBFbmFibGUgdnJhLWluaXQKc3lzdGVtY3RsIGVuYWJsZSB2cmEtaW5pdAojIFJlbW92ZSB2cmEtaW5pdCBQaGFzZSBDaGVja2VyCnJtIC1yZiAvZXRjL3ZyYS1yZWFkeQojIFJlbW92ZSBVYnVudHUgTmV0d29yayBGaWxlcwpybSAtcmYgL2V0Yy9uZXR3b3JrL2ludGVyZmFjZXMKcm0gLXJmIC9ldGMvbmV0cGxhbi8qCiMgUmVtb3ZlIENlbnRPUyBOZXR3b3JrIEZJbGVzCnJtIC1yZiAvZXRjL3N5c2NvbmZpZy9uZXR3b3JrLXNjcmlwdHMvaWZjZmctKgojIFJlbW92ZSBDbG91ZCBpbml0IERhdGEKcm0gLXJmIC92YXIvbGliL2Nsb3VkLyoKIyBHZW5lcmFsIENsZWFyaW5nCi91c3IvYmluL2ltYWdlLWNsZWFyLXBvd2Vyb2Zm"
IMG_CL_PO="IyEvYmluL2Jhc2gKcm0gLXJmIC90bXAvKgpybSAtcmYgL3Zhci90bXAvKgpybSAtcmYgL3Zhci9sb2cvdm13YXJlLSoKcm0gLXJmIC92YXIvbG9nL2Nsb3VkLSoKZm9yIGZkIGluICQoZmluZCAvdmFyL2xvZyB8IGdyZXAgIi5neiIpOyBkbyBybSAtcmYgJGZkOyBkb25lCmZvciBmZCBpbiAkKGZpbmQgL3Zhci9sb2cgfCBncmVwICIudHoiKTsgZG8gcm0gLXJmICRmZDsgZG9uZQpmb3IgZmQgaW4gJChmaW5kIC92YXIvbG9nIHwgZ3JlcCAiLnppcCIpOyBkbyBybSAtcmYgJGZkOyBkb25lCmZvciBmZCBpbiAkKGZpbmQgL3Zhci9sb2cgfCBncmVwICIuYnoyIik7IGRvIHJtIC1yZiAkZmQ7IGRvbmUKcm0gLXJmIH4vLmJhc2hfaGlzdG9yeQpwb3dlcm9mZg=="
echo "$VRA_INIT_SVC" | base64 -d | tee /lib/systemd/system/vra-init.service > /dev/null
echo "$VRA_INIT" | base64 -d | tee /usr/bin/vra-init > /dev/null
echo "$VRA_READY" | base64 -d | tee /usr/bin/vra-ready > /dev/null
echo "$IMG_CL_PO" | base64 -d | tee /usr/bin/image-clear-poweroff > /dev/null
chmod 755 /usr/bin/vra-init /usr/bin/vra-ready /usr/bin/image-clear-poweroff
systemctl disable vra-init

# clear unusable packages
yum clean all

# finish
echo ""
echo "if want to make image to finalize"
echo "input command as followed"
echo ""
echo "  # vra-ready"
echo ""
echo "thanks"
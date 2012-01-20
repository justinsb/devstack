# One-off config

# Import the SMF for KVM
sudo svccfg import /opt/stack/nova/smf/kvm.xml 
sudo ln -s /opt/stack/nova/smf/kvm-instance-smf /usr/bin

# Touching this file means "don't use hardware acceleration" - great for VMs / Zones
sudo touch /etc/qemu/disable-kvm

# We 
sudo dladm create-vnic -l rge0 vnic_metadata_0
sudo ifconfig vnic_metadata_0 plumb
sudo ifconfig vnic_metadata_0 169.254.169.254
sudo ifconfig vnic_metadata_0 up

WHO_AM_I=`whoami`

# How to find these: http://developers.sun.com/developer/technicalArticles/opensolaris/pfexec.html

# Network Management - for dladm
# ZFS File System Management - to chown the zvol device so we can write to it
# ZFS File System Management - for zfs volumes
# TODO: Better to use zfs delegated administration than ZFS File System Management??
# http://blogs.oracle.com/marks/entry/zfs_delegated_administration
# NOTE: These overwrite the profiles
#sudo usermod -P'Object Access Management,Network Management,ZFS File System Management' ${WHO_AM_I}

# I couldn't get the above to work; specifically chmod on the zvol device is failing
sudo usermod -P'Primary Administrator' ${WHO_AM_I}


# My main ZFS pool isn't called rpool (!)
export EXTRA_FLAGS="--illumos_zvol_base=rpool1/kvm --setup_nat_for_metadata=false"
export PUBLIC_INTERFACE=rge0
export HOST_IP=127.0.0.1

export FLAT_INTERFACE=${PUBLIC_INTERFACE}

./stack.sh


# USERNAME is set to the USERNAME, which screws up NOVA_USERNAME.  Clear it.
USERNAME=
source ./openrc
./exercise.sh



# Update /etc/hosts

sudo cp /etc/hosts /etc/hosts.bkpz
sudo cp etc_new_hosts /etc/hosts


# Create Directories for NN/DN/JN

sudo mkdir -p /data1/nn /data1/jn

# Change Directory Permissions.

sudo chown hdadmin:hdadmin /data1/nn
sudo chown hdadmin:hdadmin /data1/jn


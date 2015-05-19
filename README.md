# Ansible Playbook - Setup Hadoop CDH5 Using `tarball`.


This is a simple Hadoop playbook, to quickly start hadoop running on in a cluster.

Here is the Script Location on Github: https://github.com/zubayr/ansible_zookeeper_tarball

Below are the steps to get started.

## Before we start.

Download [`hadoop-2.3.0-cdh5.1.2.tar.gz`](http://archive.cloudera.com/cdh5/cdh/5/hadoop-2.3.0-cdh5.1.2.tar.gz) to `file_archives` directory.

Download [`jdk-7u75-linux-x64.tar.gz`](http://www.oracle.com/technetwork/java/javase/downloads/java-archive-downloads-javase7-521261.html#jdk-7u75-oth-JPR) to `file_archives` directory.

## Get the script from Github.

Below is the command to clone. 

    ahmed@ahmed-server ~]$ git clone https://github.com/zubayr/ansible_hadoop_tarball

## Step 1. Update below variables as per requirement.


Global Vars can be found in the location `group_vars/all`.

    # --------------------------------------
    # USERs
    # --------------------------------------
    
    hadoop_user: hdadmin
    hadoop_group: hdadmin
    hadoop_password: $6$rounds=40000$1qjG/hovLZOkcerH$CK4Or3w8rR3KabccowciZZUeD.nIwR/VINUa2uPsmGK/2xnmOt80TjDwbof9rNvnYY6icCkdAR2qrFquirBtT1

    # Common Location information.
    common:
      install_base_path: /usr/local
      soft_link_base_path: /opt


## Step 2. User information come from `global_vars`.

Username can be changed in the Global Vars, `zookeeper_user`.
Currently the password is `hdadmin@123`

Password can be generated using the below python snippet.

    # Password Generated using python command below.
    python -c "from passlib.hash import sha512_crypt; import getpass; print sha512_crypt.encrypt(getpass.getpass())"

Here is the execution. After entering the password you will get the encrypted password which can be used in the user creation.

    ahmed@ahmed-server ~]$ python -c "from passlib.hash import sha512_crypt; import getpass; print sha512_crypt.encrypt(getpass.getpass())"
    Enter Password: *******
    $6$rounds=40000$1qjG/hovLZOkcerH$CK4Or3w8rR3KabccowciZZUeD.nIwR/VINUa2uPsmGK/2xnmOt80TjDwbof9rNvnYY6icCkdAR2qrFquirBtT1
    ahmed@ahmed-server ~]$

## Step 3. Update Host File. 

IMPORTANT update contents of `hosts` file. 
In `hosts` file `host_name` is used to create the `/etc/hosts` file. 


    #
    # All pre-prod nodes. 
    #
    [allnodes]
    10.10.18.30 host_name=ahmd-namenode
    10.10.18.31 host_name=ahmd-datanode-01
    10.10.18.32 host_name=ahmd-datanode-02
    10.10.18.34 host_name=ahmd-resourcemanager
    10.10.18.93 host_name=ahmd-secondary-namenode
    10.10.18.94 host_name=ahmd-datanode-03
    10.10.18.95 host_name=ahmd-datanode-04
    
    
    # 
    # hadoop cluster
    #
    
    [namenodes]
    10.10.18.30
    
    [secondarynamenode]
    10.10.18.93
    
    [resourcemanager]
    10.10.18.34
    
    [jobhistoryserver]
    10.10.18.34
    
    [datanodes]
    10.10.18.31
    10.10.18.32
    10.10.18.94
    10.10.18.95
    
    [hadoopcluster:children]
    namenodes
    secondarynamenode
    resourcemanager
    jobhistoryserver
    datanodes
    
    #
    # sshknown hosts list.
    #
    
    [sshknownhosts:children]
    hadoopcluster


## Step 4. Post Installation.

This is hadoop user creation after installation.
If we need more users then we need to add them in role `post_install_setups`.

Current we will create a user called `stormadmin`. More details in `roles/post_install_setups/tasks/create_hadoop_user.yml`

    #
    # Creating a Storm User on Namenode/ This will eventually be a edge node.
    #
    - hosts: namenodes
      remote_user: root
      roles:
        - post_install_setups

    

## Step 5. Executing yml.

Execute below command. 

    ansible-playbook ansible_hadoop.yml -i hosts --ask-pass
    

 
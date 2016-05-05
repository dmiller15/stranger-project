This document is available online [here](https://gist.github.com/cczysz/4b4c563b776a04d1de7b6ac3490e4d8e)

# Starting out with OSDC/PDC

* Create and log in to your account
* Add an ssh key to access the login node from your computer
* Add an ssh key to access the VM from the login node
* Spin up a VM
* Access S3 storage

## Logging in

[PDC](https://bionimbus-pdc.opensciencedatacloud.org/console)
Login using your NIH credentials

[OSDC](https://www.opensciencedatacloud.org/console/)
Login via Uchicago Shibboleth

## Adding an ssh key

Once you're logged in to your console, you should see 4 submenu items along the top

* Overview
* Instances
* Images and Snapshots
* Access and Security

Click on Access and Security to add your ssh keypair.

The OSDC instrunctions for this are [here](https://www.opensciencedatacloud.org/support/ssh.html).

### Mac/Linux

Run `ssh-keygen` and follow the prompts to create a new keypair or use an already existing one (such as `id_rsa`).

Back on the OSDC website, 

* Click "Import Keypair", 
* Input a descriptive name (such as laptop or lab-desktop) 
* Paste the contents of your public key into the box. 
* Choose 'login server' from the dropdown box.  

And finally click 'Import Keypair'

### Configuring your ssh config

To make ssh'ing into the login node easier, create/edit `~/.ssh/config` and add the following lines:

```
Host griffin # You can change this to be any alias you'd like
HostName griffin.opensciencedatacloud.org
# HostName bionimbus-pdc.opensciencedatacloud.org # To access the PDC
User # input your login name here
PubkeyAuthentication yes
AgentForwarding yes
```

Now, to access the cluster you'll just need to type:

`ssh <Host>`

## Adding an ssh keypair for the login node

SSH into the griffin login node and repeat the previous Mac/Linux steps to generate a keypair on the login node.

Under Access and Security in the web console:

* Click Import Keypair
* Name your keypair the same name you used for the `nova` command earlier
* Paste the contents of the public keyfile you created on the login node
* Choose 'Instances' from the drop down menu

Finally, click Import Keypair.

## Spinning up a VM

A VM is where you'll actually be doing your work. 

Back in the web console, click on the Images & Snapshots tab.

This brings up a list of the default images (Docker and several Ubuntu setups) as well as user-generated Snapshots.

To spin up a VM, select your image of choice and click Launch. This brings up a dialog where you specify the resources the VM will use. The available 'flavors' and listed [here](https://www.opensciencedatacloud.org/support/griffin.html#osdc-griffin-flavors). The lab shares these resources, so try to request the minimum you need to complete your job. 

Also in the creation dialog, click Access & Security and choose the second keypair you added (it should be the only one available). This will automatically add the private key to the VM so you can log in easily.

Click Launch, and you should be taken to the Instances tab, where the status of the VM you just launched should be displayed. This page will give you the IP address you will need to access the VM.

Once the IP address is given, return to the terminal session and ssh into the login node. Then ssh into the VM:

`ssh -A ubuntu@<IP>`

You should then be in the VM and are able to run your analyses.

### VM Flavors and Snapshots

The default flavors available have the default packages installed. You, however, and install your own packages from apt-get or github or curl, etc.

These outside resources must be accessed through a proxy. The simplest way to achieve this is to append to your `.bashrc`:

```
export no_proxy="griffin-objstore.opensciencedatacloud.org"
function with_proxy() {
     PROXY='http://cloud-proxy:3128'
     http_proxy="${PROXY}" https_proxy="${PROXY}" $@
}
```
Or, for the PDC:

```
export no_proxy="bionimbus-objstore.opensciencedatacloud.org"
function with_proxy() {
     PROXY='http://cloud-proxy:3128'
     http_proxy="${PROXY}" https_proxy="${PROXY}" $@
}
```

Run `source .bashrc` and you will be able to access external resources by prefixing the usual commands with `with_proxy`.

For example:

`git clone` becomes `with_proxy git clone`

and

`sudo apt-get install` becomes `with_proxy sudo -E apt-get install`

The power of snapshots becomes apparent as you install software you need to the vanilla images. To save the VM and all installed software, go to the web console, click 'Images & Snapshots' and click Save Snapshot at the appropriate entry. 

You will be able to name this snapshot and boot it later.

### Update CRAN repository


The default version of R installed will be R/3.0.2.

We need to update the CRAN repos searched by `apt-get`

Append to `/etc/apt/sources.list.d/sources.list`

`deb http://cran.case.edu/bin/linux/ubuntu trusty/`

Now, add the gpg key for the CRAN repo

`with_proxy sudo -E apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E084DAB9`

----

Alternatively

    with_proxy gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E084DAB9

and then feed it to apt-key with

    gpg -a --export E084DAB9 | sudo apt-key add -

----

Update the repo information and install R

`with_proxy sudo -E apt-get update`

`with_proxy sudo -E apt-get install r-base`
    
## File Storage

We are allocated 1Tb of object storage via CEPH, an s3 compatible file system.

This file storage is set up as sets of 'buckets', top level folders which can contain their own directory structure.

There are two easy ways to access this storage

### GUI access

Mac and PC users can use the free program [Cyberduck](https://cyberduck.io/) to connect to s3 storage.

* Click Open Connection
* Input `griffin-objstore.opensciencedatacloud.org` as the server
* Input your access key as the username
* Input your secret key as the password
 
Once you log in, create a new bucket (folder) for your project and upload files as necessary.

### CLI Access

Once you have data in storage, you will want to access it from your VM. The developers of Cyberduck have a [CLI program](https://duck.sh/) to do this.

#### Installing duck.sh

Append to `/etc/apt/sources.list.d/sources.list`

`deb https://s3.amazonaws.com/repo.deb.cyberduck.io stable main`

Add the gpg key

`with_proxy sudo -E apt-key adv --keyserver hpk://keyserver.ubuntu.com:80 --recv-keys FE7097963FEFBE72`

Update the package list

`with_proxy sudo -E apt-get update`

Install duck.sh

`with_proxy sudo -E apt-get install duck`

#### Using duck.sh

You will need to install a new profile to access the object storage using `duck`. Copy the file [here](https://gist.github.com/cczysz/6b8b37a67801e22e1b652a0578b66c19) to `~/.duck/profiles/`

Once this profile is set up, you can access the object storage via `duck` commands.

`duck --list cdis://~ --username <access> --password <secret>`
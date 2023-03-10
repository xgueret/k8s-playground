# How To Install Docker On The Control Plane Node



Create a docker group. Users in this group will have permission to use Docker on the system:

```shell
sudo groupadd docker
```



<u>Install required packages.</u> 

> **Note**: Some of these packages may already be present on the system, but including them here will not cause any problems:

```shell
sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
```



Set up the Docker GPG key and package repository:

```shell
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
| sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```



Install the Docker Engine:

```shell
sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli
```

:warning: **keep the default answer** !!!     :point_right:  **`N`**

```shell
Configuration file '/etc/containerd/config.toml'
 ==> File on system created by you or by a script.
 ==> File also in package provided by package maintainer.
   What would you like to do about it ?  Your options are:
    Y or I  : install the package maintainer's version
    N or O  : keep your currently-installed version
      D     : show the differences between the versions
      Z     : start a shell to examine the situation
 The default action is to keep your current version.
*** config.toml (Y/I/N/O/D/Z) [default=N] ? 
```



Test the Docker setup:

```shell
sudo docker version
```



Add **vagrant** to the **docker group** in order to give **vagrant** access to use Docker:

```shell
sudo usermod -aG docker vagrant
```



Log out of the server and log back in.

Test your setup:

```shell
docker version
```



all is done :tada:

```shell
which docker
# /usr/bin/docker
```

